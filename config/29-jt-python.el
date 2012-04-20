(add-to-list 'load-path (concat thirdparty-dir "python-mode/"))
(setq py-install-directory (concat thirdparty-dir "python-mode/"))
(add-hook 'python-mode-hook
          (lambda ()
            (setq py-shell-name "ipython")
            (setq py-python-command "ipython")
            (setq py-python-command-args '("-i" "-colors" "Linux"))
            (setq py-indent-offset 4)))
(require 'python-mode)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(require 'ipython)

;; ipython completion using ido
(setq ipython-completion-command-string "print ';'.join(__IP.Completer.all_completions('%s')) #PYTHON-MODE SILENT\n")
(defvar ipython-completion-file-command-string "print ';'.join(__IP.Completer.file_matches('%s')) #PYTHON-MODE SILENT\n")
(defvar ipython-all-completions "print ';'.join(__IP.complete('') #PYTHON-MODE SILENT\n")
(defvar ipython-all-file-completions "print ';'.join(__IP.Completer.file_matches('') #PYTHON-MODE SILENT\n")

(defvar file_match_cmds '("cd "
                          "ls "
                          "less "
                          ))
(setq file_match_cmds '("cd "
                        "ls "
                        "less "
                        "mkdir "
                        "cat "
                        "mv "
                        "rmdir "
                        "rm "
                        "cp "
                        "ll "
                        "lf "
                        "lc "
                        "ldir "
                        "lx "
                        "lk "
                        "clear"
                        ))

(defun ipython-completion-args (pattern all)
  (message all)
  ;; first check if command is in file matches
  (let ((file_match nil)
        (all_match nil))
    (if all
        (dolist (cmd file_match_cmds)
          (if (and (>= (length all) (length cmd)) (equalp cmd (substring all 0 (length cmd))))
              (progn 
                (message "%s %s" file_match cmd)
                (setq file_match t)))))
    (message "%s" file_match)
    (cond ((and pattern (not file_match))
           (format ipython-completion-command-string pattern))
          ((and pattern file_match)
           (format ipython-completion-file-command-string pattern))
          (file_match
           ipython-all-file-completions)
          (t
           ipython-all-completions))))

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
         (beg (save-excursion (skip-chars-backward "a-z0-9A-Z_./" (point-at-bol))
                              (point)))
         (end (point))
         (pattern (buffer-substring-no-properties beg end))
         (all (buffer-substring-no-properties (point-at-bol) (point)))
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
                         (ipython-completion-args pattern all))
    (accept-process-output python-process)
    (setq completions
          (split-string (substring ugly-return 0 (position ?\n ugly-return)) sep))
    (setq completions (mapcar (lambda (x) (if (equalp (substring x 0 1) "%") (substring x 1) x)) completions))
    (message "%s" (concat "DEBUG completions: " (mapconcat (lambda (x) x) completions " ")))
    (setq completion-table (loop for str in completions
                                 collect (list str nil)))
    (setq completion (try-completion pattern completion-table))
    (cond ((eq completion t))
          ((null completion)
           (message "Can't find completion for \"%s\"" pattern)
           (ding))
          ((not (string= pattern completion))
           (delete-region beg end)
           (insert completion))
          (t
           (let ((result (ido-completing-read "Completion: " (all-completions pattern completion-table))))
             (delete-char (- (length pattern)))
             (insert result))))))

;; patched to filter out colors
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



;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FLYMAKE FOR PYTHON
;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'python-mode-hook 'flymake-find-file-hook)

(defun python-flymake-create-copy-file ()
  "Create a copy local file"
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace)))
    (file-relative-name
     temp-file
     (file-name-directory buffer-file-name))))

(defun python-flymake-command-parse (cmdline)
  "Parses the command line CMDLINE in a format compatible
       with flymake, as:(list cmd-name arg-list)

The CMDLINE should be something like:

 flymake %f python custom.py %f

%f will be substituted with a temporary copy of the file that is
 currently being checked.
"
  (let ((cmdline-subst (replace-regexp-in-string "%f" (python-flymake-create-copy-file) cmdline)))
    (setq cmdline-subst (split-string-and-unquote cmdline-subst))
    (list (first cmdline-subst) (rest cmdline-subst))
    ))

(defun python-setup-checker (cmdline)
  (add-to-list 'flymake-allowed-file-name-masks
               (list "\\.py\\'" (apply-partially 'python-flymake-command-parse cmdline)))
  )


(defun python-shift-left ()
  (interactive)
  (let (start end bds)
    (if (and transient-mark-mode
             mark-active)
	(setq start (region-beginning) end (region-end))
      (progn
	(setq bds (bounds-of-thing-at-point 'line))
	(setq start (car bds) end (cdr bds))))
  (python-indent-shift-left start end))
  (setq deactivate-mark nil)
)

(defun python-shift-right ()
  (interactive)
  (let (start end bds)
    (if (and transient-mark-mode
             mark-active)
	(setq start (region-beginning) end (region-end))
      (progn
	(setq bds (bounds-of-thing-at-point 'line))
	(setq start (car bds) end (cdr bds))))
  (python-indent-shift-right start end))
  (setq deactivate-mark nil)
)

(defun flymake-python ()
  (require 'flymake)
  (require 'flymake-cursor)
  (flymake-mode)
  (flymake-cursor-mode 1)
  (python-setup-checker "pyflakes %f")
  (define-key py-mode-map (kbd "M-n") 'flymake-goto-next-error)
  (define-key py-mode-map (kbd "M-p") 'flymake-goto-prev-error)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ropemacs
;;;;;;;;;;;;;;;;;;;;;;;;;;
;; pymacs
(add-to-list 'load-path (concat thirdparty-dir "Pymacs/"))
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(autoload 'pymacs-autoload "pymacs")

;; ropemacs
(defun setup-ropemacs ()
  "Setup the ropemacs harness"
  ;; (setenv "PYTHONPATH"
  ;;         (concat
  ;;          (getenv "PYTHONPATH") path-separator))
  (pymacs-load "ropemacs" "rope-")

  ;; Stops from erroring if there's a syntax err
  (setq ropemacs-codeassist-maxfixes 3)

  ;; Configurations
  (setq ropemacs-guess-project t)
  (setq ropemacs-enable-autoimport t)
  (setq ropemacs-autoimport-modules '("os" "shutil" "sys" "logging"))
  ;; Adding hook to automatically open a rope project if there is one
  ;; in the current or in the upper level directory
  (add-hook 'python-mode-hook
            (lambda ()
              (find-file-and-run-fn ".ropeproject"
                                    (lambda (name)
                                      (rope-open-project name))))))



;; new keybindings
(add-hook 'python-mode-hook
          '(lambda () 
             (progn
               (setup-ropemacs)
               (flymake-python)
               (define-key py-mode-map (kbd "C-S-<right>") 'python-shift-right)
               (define-key py-mode-map (kbd "C-S-<left>") 'python-shift-left)
               (define-key py-mode-map (kbd "C-m") 'newline-and-indent)
               (define-key py-mode-map (kbd "M-a") 'python-nav-sentence-start)
               (define-key py-mode-map (kbd "M-e") 'python-nav-sentence-end))))
