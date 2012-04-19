(autoload 'ack-and-a-half-same "ack-and-a-half" nil t)
(autoload 'ack-and-a-half "ack-and-a-half" nil t)
(autoload 'ack-and-a-half-find-file-same "ack-and-a-half" nil t)
(autoload 'ack-and-a-half-find-file "ack-and-a-half" nil t)

(if linux-p
    (setq ack-and-a-half-executable (executable-find "ack-grep")))

(defalias 'ack 'ack-and-a-half)
(defalias 'ack-same 'ack-and-a-half-same)
(defalias 'ack-find-file 'ack-and-a-half-find-file)
(defalias 'ack-find-file-same 'ack-and-a-half-find-file-same)

(global-set-key (kbd "C-c a") 'ack)

(defvar ack-cmd)
(if macosx-p
    (setq ack-cmd (executable-find "ack"))
  (setq ack-cmd (executable-find "ack-grep")))

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
