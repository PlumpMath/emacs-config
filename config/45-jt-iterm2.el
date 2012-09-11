;; hack for iterm: rebind C-<return> to "^[[1;99"
(define-key input-decode-map "[1;99Z" [C-return])
;(global-set-key "[1;99" 'cua-set-rectangle-mark)

;; For iterm in terminal
(define-key input-decode-map "[1;2D" [S-left])
(define-key input-decode-map "[1;2C" [S-right])
(define-key input-decode-map "[1;2A" [S-up])
(define-key input-decode-map "[1;2B" [S-down])

(define-key input-decode-map "[1;5D" [C-left])
(define-key input-decode-map "[1;5C" [C-right])
(define-key input-decode-map "[1;5A" [C-up])
(define-key input-decode-map "[1;5B" [C-down])

(define-key input-decode-map "[1;9D" [M-left])
(define-key input-decode-map "[1;9C" [M-right])
(define-key input-decode-map "[1;9A" [M-up])
(define-key input-decode-map "[1;9B" [M-down])

(define-key input-decode-map "[1;10D" [M-S-left])
(define-key input-decode-map "[1;10C" [M-S-right])
(define-key input-decode-map "[1;10A" [M-S-up])
(define-key input-decode-map "[1;10B" [M-S-down])
(define-key input-decode-map "[Z" [backtab])

(global-set-key "[1;99(" 'goto-match-paren) ; C-(
(global-set-key "[1;99)" 'goto-match-paren)
(global-set-key (kbd "ESC M-[ D") 'backward-word)
(global-set-key (kbd "ESC M-[ C") 'forward-word)
