;; Backups
; make backups
(setq make-backup-files t)

; never make versioned backups
(setq version-control 'never)

; preserve hard links
(setq backup-by-copying-when-linked t)

(setq delete-old-versions t)

; Create the backup file directory if it doesn't exist
(if (not (file-directory-p emacs-backups-dir))
    (make-directory emacs-backups-dir))

; save all backups in emacs-backups-dir
(setq-default
 backup-directory-alist (list (cons "." emacs-backups-dir)))

; auto-save file-visiting buffers by default
(setq auto-save-default t)

; do not auto-save buffer in the file it is visting
(setq auto-save-visited-file-name nil)

(defun tramp-backup-disable-p (name)
  (if (string-match tramp-file-name-regexp
                    name)
      nil
    (normal-backup-enable-predicate name)))

(setq backup-enable-predicate 'tramp-backup-disable-p)



(setq recentf-save-file (concat emacs-backups-dir "recentf")
      recentf-max-saved-items 1000
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
