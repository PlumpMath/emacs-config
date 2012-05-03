(add-to-list 'load-path (concat thirdparty-dir "python-mode/"))
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

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Navigation
;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FLYMAKE FOR PYTHON
;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'python-mode-hook 'flymake-find-file-hook)

(defun python-flymake-create-copy-file ()
  "Create a copy local file"
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-intemp)))
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

(defun flymake-python ()
  (require 'flymake)
  (require 'flymake-cursor)
  (flymake-mode)
  (flymake-cursor-mode 1)
  (setq flymake-run-in-place nil)
  (setq temporary-file-directory "~/.emacs.d/tmp")
  (python-setup-checker "pyflakes %f"))

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

(setq ropemacs-enable-shortcuts nil)
(pymacs-load "ropemacs" "rope-")

(defun ropemacs-complete-or-indent ()
  "if we are in whitespace to the left, move to first non-whitespace. else call completion if we have text to the left and whitespace under point."
  (interactive)
  (let ((py-indent (py-compute-indentation))
        (col (current-column)))
    (jt-message "%d %d" py-indent col)
    (if (< col py-indent)
        (forward-char (- py-indent col))
      (if (and (looking-at "[ \t\n]")
               (looking-back "[^ \t\n]"))
          (ropemacs-complete-intern)
        (jt-message "%s" "COMPLETION: not on whitespace")))))

(defun ropemacs-complete-intern ()
  (interactive)
  (let* ((beg (save-excursion (skip-chars-backward "a-z0-9A-Z_./\-" (point-at-bol))
                              (point)))
         (end (point))
         (pattern (buffer-substring-no-properties beg end))
         (completions (mapcar (lambda (c) (concat pattern c))
                              (rope-completions)))
         (result nil))
    (cond ((= 1 (length completions)) 
           (setq result (car completions)))
          (completions
           (setq result (completing-read
                         "Completion: "
                         (all-completions pattern completions)))))
    (if result
        (progn
          (delete-char (- (length pattern)))
          (insert result)))))

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
  (setq ropemacs-autoimport-modules '("os" "shutil" "sys" "logging"))
  (define-key python-mode-map (kbd "C-<tab>") 'ropemacs-complete)
  (define-key python-mode-map (kbd "C-x g") 'rope-goto-definition)
  (define-key python-mode-map (kbd "C-c o") 'rope-find-occurrences)
)


;; new keybindings
(defun setup-python-mode ()
  (progn
    ;; Adding hook to automatically open a rope project if there is
    ;; one in the current or in the upper level directory
    ;; (find-file-and-run-fn ".ropeproject"
    ;;                       (lambda (dir name)
    ;;                         (rope-open-project (concat dir name))))
    (setup-ropemacs)
    (flymake-python)

    ;; change hook to use special complete function
    (setq tab-always-indent `complete)

    (remove-hook 'completion-at-point-functions
                 py-complete-function 'local)
    (setq py-complete-function 'ropemacs-complete-or-indent)
    (add-hook 'completion-at-point-functions
              py-complete-function 'local)))

(add-hook 'python-mode-hook 'setup-python-mode)

(defun python-mode-keybindings ()
  (define-key python-mode-map (kbd "C-S-<right>") 'python-shift-right)
  (define-key python-mode-map (kbd "C-S-<left>") 'python-shift-left)
  (define-key python-mode-map (kbd "C-m") 'newline-and-indent)
  (define-key python-mode-map (kbd "M-a") 'python-nav-sentence-start)
  (define-key python-mode-map (kbd "M-e") 'python-nav-sentence-end)
  (define-key python-mode-map (kbd "<backtab>") 'ipython-complete)
  (define-key python-mode-map (kbd "C-c g") 'google-suggest) ; this is taken by python-mode
  (define-key python-mode-map (kbd "C-c C-a") 'ack-at-point-and-switch) ; this is taken by mark-line
  (define-key python-mode-map (kbd "M-n") 'flymake-goto-next-error)
  (define-key python-mode-map (kbd "M-p") 'flymake-goto-prev-error)
  )

(defun py-shell-keys-and-fix ()
  (autopair-mode -1)
  (define-key inferior-python-mode-map (kbd "C-j") 'ipython-send-and-indent)
  (define-key inferior-python-mode-map (kbd "<return>") 'ipython-send-and-indent))
(add-hook 'py-shell-hook 'py-shell-keys-and-fix t)


;; keybindings are appended to hook so they overwrite other settings
(add-hook 'python-mode-hook 'python-mode-keybindings t)
