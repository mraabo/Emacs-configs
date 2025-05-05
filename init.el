(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(lsp-mode svg-tag-mode olivetti org-download magit org-roam org-fragtog org-appear org-superstar jinx pdf-tools doom-themes auctex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
)

(tool-bar-mode -1)
(menu-bar-mode -1)
(blink-cursor-mode -1)
(toggle-scroll-bar -1)
(toggle-frame-maximized)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'org-mode-hook 'display-line-numbers-mode)

(setq winner-mode t
      tab-bar-history-mode t
      sentence-end-double-space nil)

(set-face-attribute 'default nil :font "Iosevka" :height 170)

;; Use cmd key for meta and free option key
(setq mac-command-modifier 'meta
      mac-option-modifier 'none)

(set-register ?i (cons 'file "~/.emacs.d/init.el"))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-htb t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (nerd-icons must be installed!)
  ;(doom-themes-neotree-config)
  ;; or for treemacs users
  ;(setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  ;(doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
					;(doom-themes-org-config)
  )

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(pdf-tools-install)

(setq-default ispell-program-name "aspell")
(use-package jinx
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages)))


(use-package org
  :hook (org-mode . visual-line-mode)
        (org-mode . olivetti-mode)
  :config
  (setq org-startup-with-inline-images t
        org-startup-with-latex-preview t
        org-preview-latex-default-process 'dvisvgm ; more readable latex
        org-babel-default-header-args '(:results . "raw") ; return raw not tables
	org-hide-leading-stars t
	org-pretty-entities t)
  (dolist (face '((org-document-title . 1.8)
		  (org-level-1 . 1.35)
                  (org-level-2 . 1.3)
                  (org-level-3 . 1.2)
                  (org-level-4 . 1.1)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :weight 'bold :height (cdr face)))
  (plist-put org-format-latex-options :scale 1.35))

(use-package org-roam
  :config
  (setq org-roam-directory (file-truename "~/org/roam"))
  (org-roam-db-autosync-mode))

(use-package org-appear
  :commands (org-appear-mode)
  :hook     (org-mode . org-appear-mode)
  :config
  (setq org-hide-emphasis-markers t
        org-appear-autoemphasis   t   
        org-appear-autolinks      t))


(use-package org-fragtog
  :hook (org-mode . org-fragtog-mode))        


(use-package org-superstar
  :hook (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-leading-bullet " ")
  (setq org-superstar-headline-bullets-list '("◉" "○" "⚬" "◈" "◇"))
  (setq org-superstar-special-todo-items t)
  ;; Makes TODO header bullets into boxes
  (setq org-superstar-todo-bullet-alist '(("TODO"  . 9744)
                                          ("WAIT"  . 9744)
                                          ("READ"  . 9744)
                                          ("PROG"  . 9744)
                                          ("DONE"  . 9745))))

(defun my/prettify-symbols-setup ()
  ;; Checkboxes
  (push '("[ ]" . "") prettify-symbols-alist)
  (push '("[X]" . "") prettify-symbols-alist)
  (push '("[-]" . "" ) prettify-symbols-alist)
  ;; org-babel
  (push '("#+BEGIN_SRC" . ?≫) prettify-symbols-alist)
  (push '("#+END_SRC" . ?≫) prettify-symbols-alist)
  (push '("#+begin_src" . ?≫) prettify-symbols-alist)
  (push '("#+end_src" . ?≫) prettify-symbols-alist)
  ;; Drawers
  (push '(":PROPERTIES:" . "") prettify-symbols-alist)
  (prettify-symbols-mode))
(add-hook 'org-mode-hook        #'my/prettify-symbols-setup)

(use-package svg-tag-mode
  :hook (org-mode . svg-tag-mode)
  :config
  (defun svg-progress-percent (value)
    (svg-image (svg-lib-concat
                (svg-lib-progress-bar (/ (string-to-number value) 100.0)
                                      nil :margin 0 :stroke 2 :radius 3 :padding 2 :width 11)
                (svg-lib-tag (concat value "%")
                             nil :stroke 0 :margin 0)) :ascent 'center))
  
  (defun svg-progress-count (value)
    (let* ((seq (mapcar #'string-to-number (split-string value "/")))
           (count (float (car seq)))
           (total (float (cadr seq))))
      (svg-image (svg-lib-concat
                  (svg-lib-progress-bar (/ count total) nil
                                        :margin 0 :stroke 2 :radius 3 :padding 2 :width 11)
                  (svg-lib-tag value nil
                               :stroke 0 :margin 0)) :ascent 'center)))
  
  (setq svg-tag-tags
        `(
          ;; Progress
          ("\\(\\[[0-9]\\{1,3\\}%\\]\\)" . ((lambda (tag)
                                             (svg-progress-percent (substring tag 1 -2)))))
          ("\\(\\[[0-9]+/[0-9]+\\]\\)" . ((lambda (tag)
                                          (svg-progress-count (substring tag 1 -1)))))
          )))

(use-package org-download
  :config
  ;; Setting default directory to store images related to the use of org-download.
  (setq-default org-download-image-dir "~/org/roam/cs_notes/Assets")
  ;; Set all images to have width 600
  (setq org-download-image-org-width 500
        ;; Set links to be correctly formatted with the approach of storing in directory.
        org-download-link-format "[[file:%s]]\n"
        org-download-abbreviate-filename-function #'file-relative-name
	;; set screenshot method to macos
	org-download-screenshot-method "screencapture"
	;; Ensure images are inserted instead of their links when exporting to pdf (I think).
        org-download-link-format-function #'org-download-link-format-function-default))
 	

(add-hook 'LaTeX-mode-hook 'turn-on-reftex) 
(setq reftex-plug-into-AUCTeX t)
