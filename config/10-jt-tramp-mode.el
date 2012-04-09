;; edit files on remote matchines over ssh
(require 'tramp)
(setq tramp-default-method "ssh")

;; from http://stackoverflow.com/questions/95631/open-a-file-with-su-sudo-inside-emacs
(defun sudo-edit (&optional arg)
  (interactive "p")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))
