(require 'vc-hg)
(defconst vc-hg-annotate-re
  "^[ \t]*\\(.+?\\) \\([0-9]+\\) \\(.\\{30\\}\\)\\(?:\\(:.*\n\\)\\|\\(?: +\\(.+\\):.*\n\\)\\)")

(defun vc-hg-annotate-command (file buffer &optional revision)
  "Prepare BUFFER for `vc-annotate' on FILE.
Each line is tagged with the revision number and author, which
has a `help-echo' property containing date and file information."
  (vc-hg-command buffer 'async file "annotate" "-u" "-d" "-n"
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
                                    (match-beginning 4)))
                    (line (match-string 4 string))
                    (tag (gethash key table))
                    (inhibit-read-only t))
               (setq string (substring string (match-end 0)))
               (unless tag
                 (setq tag
                       (propertize
			(format "%s %-7.7s" rev author)
			'help-echo (format "Revision: %d, author: %s, date: %s"
                                           (string-to-number rev)
                                           author date)
                        'vc-hg-date (format "%s" date)
                        'vc-hg-rev (format "%s" rev)
			'mouse-face 'highlight))
                 (puthash key tag table))
               (goto-char (process-mark proc))
               (insert tag line)
               (move-marker (process-mark proc) (point))))
           (process-put proc :vc-left-over string)))))))

(defconst vc-hg-propertized-annotate-re
  "^[ \t]*[0-9.]+ +.+? +:")

(defun vc-hg-annotate-time ()
  (when (looking-at vc-hg-propertized-annotate-re)
    (goto-char (match-end 0))
    (vc-annotate-convert-time
     (date-to-time (get-text-property (line-beginning-position) 'vc-hg-date)))))

(defun vc-hg-annotate-extract-revision-at-line ()
  (save-excursion
    (beginning-of-line)
    (when (looking-at vc-hg-propertized-annotate-re)
      (get-text-property (line-beginning-position) 'vc-hg-rev))))
