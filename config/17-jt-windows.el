;; Shift+direction
(windmove-default-keybindings)

;; C-x o moves one direction, C-x O moves the other
(global-set-key (kbd "C-x O") (lambda () (interactive) (other-window -1)))
