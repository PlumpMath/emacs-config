;; Backups
;; set a directory for backup files instead of dumping them all over the system
; (setq make-backup-files t) ; the default
(setq version-control t)
(push (cons "." emacs-backups-dir)
      backup-directory-alist)
