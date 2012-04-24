;; Better ipython completion: only show files for system commands, handle magic
;; commands, use (ido-)completing-read

(setq-default py-which-bufname "ipython")

(defun ipython-complete ()
  "Try to complete the python symbol before point. Only knows about the stuff
 the current *Python* session."
  (interactive)
  (let* ((ugly-return nil)
         (sep ";")
         (python-process (or (get-buffer-process (current-buffer))
                                      ;XXX hack for .py buffers
                             (get-process py-which-bufname)))
         ;; XXX currently we go backwards to find the beginning of an
         ;; expression part; a more powerful approach in the future might be
         ;; to let ipython have the complete line, so that context can be used
         ;; to do things like filename completion etc.
         (beg (save-excursion (skip-chars-backward "a-z0-9A-Z_./\-" (point-at-bol))
                              (point)))
         (end (point))
         (line (buffer-substring-no-properties (point-at-bol) end))
         (pattern (buffer-substring-no-properties beg end))
         (completions nil)
         (completion-table nil)
         completion
         (comint-preoutput-filter-functions
          (append comint-preoutput-filter-functions
                  '(ansi-color-filter-apply
                    (lambda (string)
                      (setq ugly-return (concat ugly-return string))
                      "")))))
    (process-send-string python-process
                         (format ipython-completion-command-string pattern line))
    (accept-process-output python-process)
    (setq completions
          (split-string (substring ugly-return 0 (position ?\n ugly-return)) sep))
    (setq completions (mapcar (lambda (x) (if (and (> 0 (length x)) (equalp (substring x 0 1) "%")) (substring x 1) x)) completions))
    (message "%s" (concat "DEBUG completions: " (mapconcat (lambda (x) x) completions " ")))
    (setq completion-table (loop for str in completions
                                 collect (list str nil)))
    (setq completion (try-completion pattern completion-table))
    (cond ((eq completion t))
          ((null completion)
             (message "Can't find completion for \"%s\" based on line %s" pattern line)
           (ding))
          ((not (string= pattern completion))
             (delete-region (- end (length pattern)) end)
           (insert completion))
          (t
           (let ((result (completing-read "Completion: " (all-completions pattern completion-table))))
             (delete-char (- (length pattern)))
             (insert result))))))

;; patched to filter out IPython colors
(defun py-pdbtrack-track-stack-file (text)
  "Show the file indicated by the pdb stack entry line, in a separate window.

Activity is disabled if the buffer-local variable
`py-pdbtrack-do-tracking-p' is nil.

We depend on the pdb input prompt matching `py-pdbtrack-input-prompt'
at the beginning of the line.

If the traceback target file path is invalid, we look for the most
recently visited python-mode buffer which either has the name of the
current function \(or class) or which defines the function \(or
class).  This is to provide for remote scripts, eg, Zope's 'Script
\(Python)' - put a _copy_ of the script in a buffer named for the
script, and set to python-mode, and pdbtrack will find it.)"
  ;; Instead of trying to piece things together from partial text
  ;; (which can be almost useless depending on Emacs version), we
  ;; monitor to the point where we have the next pdb prompt, and then
  ;; check all text from comint-last-input-end to process-mark.
  ;;
  ;; Also, we're very conservative about clearing the overlay arrow,
  ;; to minimize residue.  This means, for instance, that executing
  ;; other pdb commands wipe out the highlight.  You can always do a
  ;; 'where' (aka 'w') command to reveal the overlay arrow.
  (let* ((origbuf (current-buffer))
         (currproc (get-buffer-process origbuf)))

    (if (not (and currproc py-pdbtrack-do-tracking-p))
        (py-pdbtrack-overlay-arrow nil)

      (let* ((procmark (process-mark currproc))
             (block (buffer-substring (max comint-last-input-end
                                           (- procmark
                                              py-pdbtrack-track-range))
                                      procmark))
             (block (ansi-color-filter-apply block))
             target target_fname target_lineno target_buffer)

        (if (not (string-match (concat py-pdbtrack-input-prompt "$") block))
            (py-pdbtrack-overlay-arrow nil)

          (setq target (py-pdbtrack-get-source-buffer block))

          (if (stringp target)
              (message "pdbtrack: %s" target)

            (setq target_lineno (car target))
            (setq target_buffer (cadr target))
            (setq target_fname (buffer-file-name target_buffer))
            (switch-to-buffer-other-window target_buffer)
            (goto-char (point-min))
            (forward-line (1- target_lineno))
            (message "pdbtrack: line %s, file %s" target_lineno target_fname)
            (py-pdbtrack-overlay-arrow t)
            (pop-to-buffer origbuf t)))))))
