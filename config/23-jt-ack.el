(require 'ack-and-a-half)

(if linux-p
    (setq ack-and-a-half-executable (executable-find "ack-grep")))

;; TODO do ido?
(defun ack-at-point-and-switch ()
  "ack and a half at point"
  (interactive)
  (let ((dir (ack-and-a-half-read-dir)))
    (ack-and-a-half-run dir
                        t
                        (read-from-minibuffer (concat "ack (dir: "
                                                      dir
                                                      "): ")
                                              (thing-at-point 'symbol)
                                              nil
                                              nil
                                              'ack-and-a-half-regexp-history
                                              )))
  (switch-to-window-by-name "*ack-and-a-half*"))

(global-set-key (kbd "C-c C-a") 'ack-at-point-and-switch)
