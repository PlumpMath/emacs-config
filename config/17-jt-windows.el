;; Shift+direction
(global-set-key (kbd "M-j") 'windmove-left)
(global-set-key (kbd "M-l") 'windmove-right)
(global-set-key (kbd "M-i") 'windmove-up)
(global-set-key (kbd "M-k") 'windmove-down)

;; C-x o moves one direction, C-x O moves the other
(global-set-key (kbd "C-x O") (lambda () (interactive) (other-window -1)))
