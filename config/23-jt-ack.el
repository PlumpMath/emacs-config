(require 'ack-and-a-half)

(if linux-p
    (setq ack-and-a-half-executable (executable-find "ack-grep")))

(defun ack-at-point-and-switch ()
  "ack and a half at point"
  (interactive)
  (let ((dir (ack-and-a-half-read-dir)))
    (ack-and-a-half-run dir
                        t
                        (read-from-minibuffer (concat "ack (dir: "
                                                      dir
                                                      "): ")
                                              (entity-at-point)
                                              nil
                                              nil
                                              'ack-and-a-half-regexp-history
                                              )))
  (switch-to-window-by-name "*Ack-and-a-half*"))

(global-set-key (kbd "C-c C-a") 'ack-at-point-and-switch)

;; Search in open buffers
(defun occur-in-open-buffers-at-point ()
  (interactive)
  (multi-occur-in-matching-buffers 
   "[^*].*" 
   (read-from-minibuffer "occur in open buffers: "
                         (entity-at-point)
                         nil
                         nil
                         'ack-and-a-half-regexp-history)))
(global-set-key (kbd "C-c a") 'occur-in-open-buffers-at-point)
