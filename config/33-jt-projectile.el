(add-to-list 'load-path (concat thirdparty-dir "projectile/"))

(require 'projectile)

;; find in project
(define-key projectile-mode-map (kbd "C-x f") 'projectile-jump-to-project-file)
(defalias 'etags 'projectile-regenerate-tags)
(defalias 'projectile-refresh 'projectile-invalidate-project-cache)
(setq projectile-enable-caching t)
(projectile-global-mode)


;; (require 'helm-projectile)
;; (global-set-key (kbd "C-c h") 'helm-projectile)
