(defun ack-grep ()
  "Use ack for grep"
  (interactive)
  (compile (read-string "Run ack as: " (concat "ack-grep --nogroup --nocolour " (thing-at-point 'symbol)))))

(global-set-key (kbd "C-c a") 'ack-grep)
