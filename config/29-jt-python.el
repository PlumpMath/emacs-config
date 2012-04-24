(add-to-list 'load-path (concat thirdparty-dir "python-mode/"))
(add-to-list 'load-path (concat thirdparty-dir "ipython/docs/emacs/"))
(require 'ipython)
(setq-default py-python-command-args '("--colors=Linux"))
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))

;; hacks for ido-mode, colors in debug
(load-file (concat library-dir "jt-ipython-hacks.el"))

(defun annotate-pdb ()
  (interactive)
  (highlight-lines-matching-regexp "import pdb")
  (highlight-lines-matching-regexp "pdb.set_trace()"))
(add-hook 'python-mode-hook 'annotate-pdb)

(defun python-add-breakpoint ()
  (interactive)
  (py-newline-and-indent)
  (insert "import ipdb; ipdb.set_trace()")
  (highlight-lines-matching-regexp "^[ 	]*import ipdb; ipdb.set_trace()"))
(define-key python-mode-map (kbd "C-c C-t") 'python-add-breakpoint)
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
(add-to-list 'load-path (concat thirdparty-dir "Pymacs/"))
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(autoload 'pymacs-autoload "pymacs")

(pymacs-load "ropemacs" "rope-")

;; ropemacs
(defun setup-ropemacs ()
  "Setup the ropemacs harness"
  ;; (setenv "PYTHONPATH"
  ;;         (concat
  ;;          (getenv "PYTHONPATH") path-separator))

  ;; Stops from erroring if there's a syntax err
  (setq ropemacs-codeassist-maxfixes 3)

  ;; Configurations
  (setq ropemacs-guess-project t)
  (setq ropemacs-enable-autoimport t)
  (setq ropemacs-autoimport-modules '("os" "shutil" "sys" "logging")))

(defun python-info-line-ends-backslash-p (&optional line-number)
  "Return non-nil if current line ends with backslash.
With optional argument LINE-NUMBER, check that line instead."
  (save-excursion
    (save-restriction
      (widen)
      (when line-number
        (goto-char line-number))
      (while (and (not (eobp))
                  (goto-char (line-end-position))
                  (python-info-ppss-context 'paren)
                  (not (equal (char-before (point)) ?\\)))
        (forward-line 1))
      (when (equal (char-before) ?\\)
        (point-marker)))))

(defun python-nav-sentence-start ()
  "Move to start of current sentence."
  (interactive "^")
  (while (and (not (back-to-indentation))
              (not (bobp))
              (when (or
                     (save-excursion
                       (forward-line -1)
                       (python-info-line-ends-backslash-p))
                     (python-info-ppss-context 'string)
                     (python-info-ppss-context 'paren))
                (forward-line -1)))))

(defun python-nav-sentence-end ()
  "Move to end of current sentence."
  (interactive "^")
  (while (and (goto-char (line-end-position))
              (not (eobp))
              (when (or
                     (python-info-line-ends-backslash-p)
                     (python-info-ppss-context 'string)
                     (python-info-ppss-context 'paren))
                (forward-line 1)))))

;; new keybindings
(add-hook 'python-mode-hook
          '(lambda () 
             (progn
               (setup-ropemacs)

               ;; Adding hook to automatically open a rope project if there is
               ;; one in the current or in the upper level directory
               (find-file-and-run-fn ".ropeproject"
                                    (lambda (name)
                                      (rope-open-project name)))
               (flymake-python)
               (define-key python-mode-map (kbd "C-S-<right>") 'python-shift-right)
               (define-key python-mode-map (kbd "C-S-<left>") 'python-shift-left)
               (define-key python-mode-map (kbd "C-m") 'newline-and-indent)
               (define-key python-mode-map (kbd "M-a") 'python-nav-sentence-start)
               (define-key python-mode-map (kbd "M-e") 'python-nav-sentence-end)
               (define-key python-mode-map (kbd "C-<tab>") 'ipython-complete)
)))
