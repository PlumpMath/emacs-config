;; Backups
;; set a directory for backup files instead of dumping them all over the system
; (setq make-backup-files t) ; the default
;; (setq version-control t)
(push (cons "." emacs-backups-dir)
      backup-directory-alist)

(setq recentf-save-file (concat emacs-backups-dir "recentf")
      recentf-max-saved-items 200
      recentf-max-menu-items 15)
(recentf-mode t)

;; savehist keeps track of some history
(setq savehist-additional-variables
      ;; search entries
      '(search ring regexp-search-ring)
      ;; save every minute
      savehist-autosave-interval 60
      ;; keep the home clean
      savehist-file (concat user-emacs-directory "savehist"))
(savehist-mode t)
