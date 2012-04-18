(add-to-list 'load-path (concat thirdparty-dir "python-mode/"))
(setq py-install-directory (concat thirdparty-dir "python-mode/"))
(add-hook 'python-mode-hook
          (lambda ()
            (setq py-shell-name "ipython")
            (setq py-python-command-args '("-i" "-colors" "Linux"))
            (setq py-indent-offset 4)))
(require 'python-mode)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(require 'ipython)

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
