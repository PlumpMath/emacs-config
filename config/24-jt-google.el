; http://groups.google.com/group/gnu.emacs.help/msg/83792e3ec0c5039b
(defun google ()
  "Googles at point or region."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (url-hexify-string 
     (if mark-active
         (buffer-substring (region-beginning) (region-end))
       (read-string "Search Google: " (thing-at-point 'symbol)))))))

(global-set-key (kbd "C-c C-g") 'google)
