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

(defun ack-grep ()
  "Use ack for grep"
  (interactive)
  (compile (read-string "Run ack as: " (concat ack-cmd " --nogroup --nocolour " (thing-at-point 'symbol)))))

(global-set-key (kbd "C-c C-a") 'ack-grep)
