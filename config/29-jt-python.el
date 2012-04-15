;; fgallina/python.el
(require 'python (concat thirdparty-dir "python/python.el"))

(defun setup-ipython ()
  (interactive)
  (setq
   python-shell-interpreter "ipython"
   python-shell-interpreter-args ""
   python-shell-prompt-regexp "In \\[[0-9]+\\]: "
   python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
   python-shell-completion-setup-code
     "from IPython.core.completerlib import module_completion"
   python-shell-completion-module-string-code
     "';'.join(module_completion('''%s'''))\n"
   python-shell-completion-string-code
     "';'.join(get_ipython().Completer.all_completions('''%s'''))\n"))

(setup-ipython)

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
  (define-key python-mode-map (kbd "M-n") 'flymake-goto-next-error)
  (define-key python-mode-map (kbd "M-p") 'flymake-goto-prev-error)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ropemacs
;;;;;;;;;;;;;;;;;;;;;;;;;;
;; pymacs
(require 'pymacs)


;; new keybindings
(add-hook 'python-mode-hook
          '(lambda () 
             (progn
               (flymake-python)
               (define-key python-mode-map (kbd "C-S-<right>") 'python-shift-right)
               (define-key python-mode-map (kbd "C-S-<left>") 'python-shift-left)
               (define-key python-mode-map (kbd "C-m") 'newline-and-indent)
               (define-key python-mode-map (kbd "M-a") 'python-nav-sentence-start)
               (define-key python-mode-map (kbd "M-e") 'python-nav-sentence-end))))
