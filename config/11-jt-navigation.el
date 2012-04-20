;; NAVIGATION
; ignore case when searching
(setq case-fold-search t)

;; Implementing search at point (C-s C-w) 
;; Src: http://emacswiki.org/emacs/SearchAtPoint
(defun isearch-yank-symbol ()
  "*Put symbol at current point into search string."
  (interactive)
  (let ((sym (symbol-at-point)))
    (if sym
        (progn
          (setq isearch-regexp t
                isearch-string (concat (regexp-quote (symbol-name sym)))
                isearch-message (mapconcat 'isearch-text-char-description isearch-string "")
                isearch-yank-flag t))
      (ding)))
  (isearch-search-and-update))

(defun occur-with-helm (input)
  (let ((helm-compile-source-functions (delq 'helm-compile-source--match-plugin (copy-sequence helm-compile-source-functions))))
    (helm :sources 'helm-c-source-occur
          :buffer "*Helm Occur*"
          :history 'helm-c-grep-history
          :input input)))

(defun occur-inside-isearch ()
  (interactive)
  (let ((case-fold-search isearch-case-fold-search))
    (occur-with-helm (if isearch-regexp isearch-string (regexp-quote isearch-string)))))
;; Activate occur inside isearch
(define-key isearch-mode-map (kbd "C-o")
  'occur-inside-isearch)

;; occur on thing at point with helm
(defun occur-thing-at-point ()
  (interactive)
  (occur-with-helm (thing-at-point 'symbol)))
(global-set-key (kbd "C-c C-o") 'occur-thing-at-point)

(define-key isearch-mode-map (kbd "C-w") 'isearch-yank-symbol)
;; Visiting lines
(global-set-key (kbd "C-x C-g") 'goto-line)

;; Easy query replace
(defalias 'qrr 'query-replace-regexp)

;; Regex search by default
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)
