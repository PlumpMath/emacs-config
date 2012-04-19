;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fonts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if mswindows-p
    (set-default-font
     "-outline-Consolas-normal-r-normal-normal-14-97-96-96-c-*-iso8859-1"))

(if linux-p
    (set-face-attribute 'default nil
                        :weight 'normal
			:family "DejaVu Sans Mono" 
			:height 135))
(if macosx-p
    (progn
      (set-default-font
       "-apple-inconsolata-medium-r-normal--13-130-72-72-m-130-iso10646-1")
      (setq default-frame-alist '((font . "-apple-inconsolata-medium-r-normal--13-130-72-72-m-130-iso10646-1")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Font lock (syntax highlighting)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; turn on syntax highlighting globally
(if (fboundp 'global-font-lock-mode)
    (global-font-lock-mode 1))

;; show matching parens
(show-paren-mode 1)
(setq show-paren-style 'parenthesis) ; mixed, expression

;; Hotkey for matching paren
(defun goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t nil)))

;; Highlight words like
(defun highlight-todos-on ()
  (font-lock-add-keywords
   nil '(("\\<\\(TODO\\|FIXME\\|HACK\\||NOCOMMIT\\)"
          1 font-lock-warning-face t))))
(setup-multiple-hooks '(lisp-mode-hook
                        emacs-lisp-mode-hook
                        text-mode-hook
                        c-mode-common-hook
                        python-mode-hook)
                      'highlight-todos-on)

;; Font size
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

;; Parens
(define-key global-map (kbd "C-)") 'goto-match-paren)
(define-key global-map (kbd "C-(") 'goto-match-paren)
