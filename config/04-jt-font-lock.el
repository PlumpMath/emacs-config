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
