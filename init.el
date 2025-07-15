(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
 '(backup-directory-alist '((".*" . "~/.emacs.d/backups/")))
 '(package-selected-packages
   '(exec-path-from-shell ein lsp-ivy lsp-haskell dap-haskell dap-mode helm-lsp lsp-ui haskell-mode quelpa gamify which-key projectile all-the-icons helpful counsel ivy doom-modeline helm lsp-mode svg-tag-mode olivetti org-download magit org-roam org-fragtog org-appear org-superstar jinx pdf-tools doom-themes auctex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.


;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)

(setq load-prefer-newer t) ;; use newer init source file even if not compiled yet

;; Global native visuals
(setq inhibit-startup-screen t) 
(tool-bar-mode -1)
(menu-bar-mode -1)
(blink-cursor-mode -1)
(toggle-scroll-bar -1)
(toggle-frame-maximized)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'org-mode-hook 'display-line-numbers-mode)

;; Global formatting
(setq winner-mode t
      tab-bar-history-mode t
      sentence-end-double-space nil)
(set-face-attribute 'default nil :font "Iosevka" :height 170)

;; Global keybindings
;; Use cmd key for meta and free option key
(setq mac-command-modifier 'meta
      mac-option-modifier 'none)

(set-register ?i (cons 'file "~/.emacs.d/init.el"))

;; Package management
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(require 'use-package)
(setq use-package-always-ensure t) ;; adds ensure t to all packages

;; Global visuals
(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-htb t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config)
  ;; Enable custom neotree theme (nerd-icons must be installed!)
  ;(doom-themes-neotree-config)
  ;; or for treemacs users
  ;(setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  ;(doom-themes-treemacs-config)
    )
(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Navigation
(use-package ivy
  :demand t
  :diminish
  :bind (("C-s" . swiper-isearch)
	 ("M-x" . counsel-M-x)
	 ("C-x b" . ivy-switch-buffer))
  :config (ivy-mode 1)
  (counsel-mode 1))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completionsystem 'ivy))
  :bind-keymap
  ("C-c p"  . projectile-command-map))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; Documentation
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 4))

;; LaTex
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex) 
(setq reftex-plug-into-AUCTeX t)
(pdf-tools-install)
(setq LaTeX-default-environment "equation*")


;; Spelling correction
(setq-default ispell-program-name "aspell")
(use-package jinx
  :hook (emacs-startup . (lambda ()
                           (global-jinx-mode)
                           (setq jinx-languages "en_GB")))
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages)))

;; Org
(use-package org
  :hook (org-mode . visual-line-mode)
  (org-mode . olivetti-mode)
  :bind ("C-c o i" . org-id-get-create)
  :config
  (setq org-startup-with-inline-images t
        org-startup-with-latex-preview t
        org-preview-latex-default-process 'dvisvgm ; more readable latex
	org-preview-latex-image-directory "~/.emacs.d/ltximg/"
	org-hide-leading-stars t
	org-pretty-entities t
	org-ellipsis " ▾" ; change "..." on expandable headlines
	org-cite-bibliography '("/Users/mraabo/org/bibFile.bib")
	org-image-actual-width 600
	org-confirm-babel-evaluate nil
	org-startup-folded 'fold)
  (dolist (face '((org-document-title . 1.8)
		  (org-level-1 . 1.35)
                  (org-level-2 . 1.3)
                  (org-level-3 . 1.2)
                  (org-level-4 . 1.1)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :weight 'regular :height (cdr face)))
  (plist-put org-format-latex-options :scale 1.75))
 

(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/org/roam"))
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
	 ("C-c n c" . org-roam-capture))
  :config
  (org-roam-db-autosync-enable))

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
  (setq org-superstar-item-bullet-alist '((?* . ?•) (?+ . ?➤)(?- . ?•)))
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
        ;; Progress
        `(
          ("\\(\\[[0-9]\\{1,3\\}%\\]\\)" . ((lambda (tag)
              (svg-progress-percent (substring tag 1 -2)))))
          ("\\(\\[[0-9]+/[0-9]+\\]\\)" . ((lambda (tag)
              (svg-progress-count (substring tag 1 -1))))))))

(use-package org-download
  :config
  ;; Setting default directory to store images related to the use of org-download.
  (setq-default org-download-image-dir "~/org/roam/cs_notes/Assets")
  ;; Set all images to have width 600
  (setq org-download-link-format "[[file:%s]]\n" ; format links
        org-download-abbreviate-filename-function #'file-relative-name
	;; set screenshot method to macos
	org-download-screenshot-method "screencapture"
	;; Ensure images are inserted instead of their links when exporting to pdf (I think).
        org-download-link-format-function #'org-download-link-format-function-default))


;; Gamify own version
(load-file "~/projects/emacs/gamify/gamify.el")
;;(require 'gamify)
(setq gamify-org-p t)                    ;; Enable Org integration
(setq gamify-stats-file "~/.emacs.d/gamify-stats")  ;; Optional: set custom path
(setq gamify-focus-stats '("Haskell")) ;; Set initial viewpoint of bar - set to what your working on.
(gamify-setup-progress-bars)
(setq gamify-format "%Lf %PBF")  ; Shows: Level [████░░░░] pct%
(setq gamify-org-roam-p t)  ; Enable Org Roam gamification
(gamify-start)


;; Copy shell PATH to emacs env, since Emacs.app runs isolated env.
(use-package exec-path-from-shell
  :init
  (when (memq window-system '(mac ns))
  (setenv "SHELL" "/bin/zsh")
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-envs
   '("PATH"))))

;; Haskell
(use-package haskell-mode)
(let ((my-ghcup-path (expand-file-name "~/.ghcup/bin")))
  (setenv "PATH" (concat my-ghcup-path ":" (getenv "PATH")))
  (add-to-list 'exec-path my-ghcup-path))

;; Python
(use-package python-mode
  :ensure nil
  :hook (python-mode . lsp-deferred)
  :custom
  (python-shell-interpreter "python3"))

(use-package ein
  :config
  (setq ein:output-area-inlined-images t))


;; lsp
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook ((haskell-mode . lsp)
	 (haskell-literate-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration)
	 (python-mode . lsp))
  :commands lsp)

(use-package lsp-ui :commands lsp-ui-mode)
;; (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package dap-mode)

(use-package lsp-haskell
  :after lsp-mode)
