(require 'vc-hg)
(defconst vc-hg-annotate-re
  "^[ \t]*\\(.+?\\) \\([0-9]+\\) \\(.\\{30\\}\\) *\\(.*?\\)\\(:.*\n\\)")

(defun vc-hg-annotate-command (file buffer &optional revision)
  "Prepare BUFFER for `vc-annotate' on FILE.
Each line is tagged with the revision number and author, which
has a `help-echo' property containing date and file information."
  (vc-hg-command buffer 'async file "annotate" "-u" "-d" "-n" "--follow"
                 (when revision (concat "-r" revision)))
  (lexical-let ((table (make-hash-table :test 'equal)))
    (set-process-filter
     (get-buffer-process buffer)
     (lambda (proc string)
       (when (process-buffer proc)
         (with-current-buffer (process-buffer proc)
           (setq string (concat (process-get proc :vc-left-over) string))
           (while (string-match vc-hg-annotate-re string)
             (let* ((rev (match-string 2 string))
                    (author (match-string 1 string))
                    (date (match-string 3 string))
                    (key (substring string (match-beginning 0)
                                    (match-beginning 5)))
                    (follow-file (match-string 4 string))
                    (line (match-string 5 string))
                    (tag (gethash key table))
                    (inhibit-read-only t))
               (setq string (substring string (match-end 0)))
               (unless tag
                 (setq tag
                       (propertize
			(format "%s %s" rev author)
                        'vc-hg-date (format "%s" date)
                        'vc-hg-rev (format "%s" rev)
                        'vc-hg-file (format "%s" follow-file)
			'kbd-help (format "Revision: %d, author: %s, date: %s file: %s"
                                           (string-to-number rev)
                                           author date follow-file)
			'mouse-face 'highlight))
                 (puthash key tag table))
               (goto-char (process-mark proc))
               (insert tag line)
               (move-marker (process-mark proc) (point))))
           (process-put proc :vc-left-over string)))))))

(defconst vc-hg-propertized-annotate-re
  "^[ \t]*[0-9.]+ +.+? *:")

(defun vc-hg-annotate-time ()
  (when (looking-at vc-hg-propertized-annotate-re)
    (goto-char (match-end 0))
    (vc-annotate-convert-time
     (date-to-time (get-text-property (line-beginning-position) 'vc-hg-date)))))

(defun vc-hg-annotate-extract-revision-at-line ()
  (save-excursion
    (beginning-of-line)
    (when (looking-at vc-hg-propertized-annotate-re)
      (let ((rev (get-text-property (line-beginning-position) 'vc-hg-rev))
            (file (get-text-property (line-beginning-position) 'vc-hg-file)))
        (if (> (length file) 0)
            (cons rev (expand-file-name file (vc-hg-root default-directory)))
          rev)))))

(defconst vc-git-annotate-re
  "\\([0-9a-f]+\\) *\\([^() ]*\\) *(\\(.*\\) \\([0-9]+\\)-\\([0-9]+\\)-\\([0-9]+\\) \\([0-9]+\\):\\([0-9]+\\):\\([0-9]+\\) \\([-+0-9]+\\) +\\([0-9]+\\)) \\(.*\n\\)")

(defun vc-git-annotate-command (file buf &optional rev)
  (let ((name (file-relative-name file)))
    (vc-git-command buf 'async nil "blame" "--date=iso" "-C" "-C" rev "--" name)
    (lexical-let ((table (make-hash-table :test 'equal)))
      (set-process-filter
       (get-buffer-process buf)
       (lambda (proc string)
         (when (process-buffer proc)
           (with-current-buffer (process-buffer proc)
             (setq string (concat (process-get proc :vc-left-over) string))
             (while (string-match vc-git-annotate-re string)
               (let* ((rev (match-string 1 string))
                      (follow-file (match-string 2 string))
                      (author (match-string 3 string))
                      (date-string (substring string (match-beginning 4) (match-end 10)))
                      (key (substring string (match-beginning 0)
                                      (match-beginning 12)))
                      (line (match-string 12 string))
                      (tag (gethash key table))
                      (inhibit-read-only t))
                 (setq string (substring string (match-end 0)))
                 (unless tag
                   (setq tag
                         (propertize
                          (format "%s %s: " rev author)
                          'vc-git-date (format "%s" date-string)
                          'vc-git-rev (format "%s" rev)
                          'vc-git-file (format "%s" follow-file)
                          'kbd-help (format "Revision: %s, author: %s, date: %s file: %s"
                                             rev author date-string follow-file)
                          'mouse-face 'highlight))
                   (puthash key tag table))
                 (goto-char (process-mark proc))
                 (insert tag line)
                 (move-marker (process-mark proc) (point))))
             (process-put proc :vc-left-over string))))))))

(defconst vc-git-propertized-annotate-re
  "^[ \t]*[0-9a-f]+ +.+? *:")

(defun vc-git-annotate-time ()
  (when (looking-at vc-git-propertized-annotate-re)
    (goto-char (match-end 0))
    (vc-annotate-convert-time
     (date-to-time (get-text-property (line-beginning-position) 'vc-git-date)))))

(defun vc-git-annotate-extract-revision-at-line ()
  (save-excursion
    (beginning-of-line)
    (when (looking-at vc-git-propertized-annotate-re)
      (let ((rev (get-text-property (line-beginning-position) 'vc-git-rev))
            (file (get-text-property (line-beginning-position) 'vc-git-file)))
        (if (> (length file) 0)
            (cons rev (expand-file-name file (vc-hg-root default-directory)))
          rev)))))
