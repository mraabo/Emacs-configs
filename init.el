(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
 '(backup-directory-alist '((".*" . "~/.emacs.d/backups/")))
 '(custom-safe-themes
   '("8c7e832be864674c220f9a9361c851917a93f921fedb7717b1b5ece47690c098" "014cb63097fc7dbda3edf53eb09802237961cbb4c9e9abd705f23b86511b0a69" "fd22a3aac273624858a4184079b7134fb4e97104d1627cb2b488821be765ff17" "0325a6b5eea7e5febae709dab35ec8648908af12cf2d2b569bedc8da0a3a81c1" default))
 '(package-selected-packages
   '(org-journal all-the-icons-ivy-rich dape dap-dlv-go go-mode go org-roam-ui python-mode fontawesome abc-mode abs-mode quelpa-use-package elfeed-org ox-hugo exec-path-from-shell lsp-ivy lsp-haskell dap-haskell dap-mode helm-lsp lsp-ui haskell-mode quelpa gamify which-key projectile all-the-icons helpful counsel ivy doom-modeline helm lsp-mode svg-tag-mode olivetti org-download magit org-roam org-fragtog org-appear org-superstar jinx pdf-tools doom-themes auctex)))
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
  (load-theme 'doom-nord t)
  ;(load-theme 'doom-htb t) ; at Applications/Emacs.app/Contents/Resources/etc/themes/
  (doom-themes-visual-bell-config)
  (doom-themes-org-config)
  ;; Enable custom neotree theme (nerd-icons must be installed!)
  ;(doom-themes-neotree-config)
  ;; or for treemacs users
  ;(setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  ;(doom-themes-treemacs-config)
  )

(use-package all-the-icons)

;; Enable awesome font globally
(set-fontset-font t '(#xf000 . #xf8ff) "Font Awesome 6 Free")

(use-package doom-modeline
  :init (doom-modeline-mode 1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(set-face-attribute 'link nil :weight 'normal) ; make links non-bold

;; Navigation

(keymap-global-set "C-x C-p" 'previous-buffer)
(keymap-global-set "C-x C-n" 'next-buffer)

(use-package ivy
  :demand t
  :diminish
  :bind (("C-s" . swiper-isearch)
	 ("M-x" . counsel-M-x)
	 ("C-x b" . ivy-switch-buffer))
  :config (ivy-mode 1)
  (counsel-mode 1))

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :ensure t
  :init (ivy-rich-mode 1))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completionsystem 'ivy))
  :bind-keymap
  ("C-c p"  . projectile-command-map))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; RSS feed
(use-package elfeed
    :custom
    (elfeed-db-directory
     (expand-file-name "elfeed" user-emacs-directory))
    (elfeed-show-entry-switch 'display-buffer)
    :bind
    ("C-c w e" . elfeed))

(use-package elfeed-org
  :after (elfeed)
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list "elfeed.org")))

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

;; Eshell
(require 'doom-themes)
(load-file "~/projects/emacs/pretty-eshell/pretty-eshell.el")

(keymap-global-set "C-x e" 'eshell)


; Copy shell PATH to emacs env, since Emacs.app runs isolated env.
(use-package exec-path-from-shell
  :init
  (when (memq window-system '(mac ns))
    ;; Use zsh as the shell
    (setenv "SHELL" "/bin/zsh")

    ;; Don’t run an interactive shell – it triggers the warning
    ;(setq exec-path-from-shell-arguments '("-l"))   ; or nil

    ;; Initialise and copy only PATH
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-envs '("PATH"))))



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
  :bind (("M-q" . jinx-correct)
         ("C-M-q" . jinx-languages)))

;; Org
(use-package org
  :hook (org-mode . visual-line-mode)
  :bind ("C-c o i" . org-id-get-create)
  :config
  ;; Visuals
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
	org-startup-folded 'fold
	org-startup-indented t
	org-pretty-entities nil)
   (set-face-attribute 'org-meta-line nil ;; make #+ lines same colour as comments
                       :foreground (face-foreground 'font-lock-comment-face))
   (set-face-attribute 'org-link nil ;; make org-links slanted instead of underlined
		       :slant 'italic :underline nil)
   
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
  (plist-put org-format-latex-options :scale 1.75)
  ;; org-clock
  (org-clock-persistence-insinuate)
  (setq org-clock-out-when-done t
	org-clock-persist t))
 

(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/org/roam"))
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
	 ("C-c n c" . org-roam-capture)
	 ("C-c n t" . org-roam-tag-add)
	 ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-enable))

(use-package org-appear ;; hides emphasis until touched by cursor
  :commands (org-appear-mode)
  :hook     (org-mode . org-appear-mode)
  :config
  (setq org-hide-emphasis-markers t
        org-appear-autoemphasis   t   
        org-appear-autolinks      t))

(use-package org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t))

(use-package org-fragtog ;; hides latex source until touched by cursor
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
                                          ("INPROG"  . 9744)
					  ("DELEGATED" . 9745)
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
         org-download-abbreviate-filename-function #'expand-file-name ; convert to absulate path
	;; set screenshot method to macos
	org-download-screenshot-method "screencapture"
	;; Ensure images are inserted instead of their links when exporting to pdf (I think).
        org-download-link-format-function #'org-download-link-format-function-default)
  :bind (("C-c n d" . org-download-clipboard)))

(use-package ox-hugo
  :pin melpa  ;`package-archives' should already have ("melpa" . "https://melpa.org/packages/")
  :after ox
  :config
  (setq org-hugo-base-dir "~/personal_website"))

(use-package org-table-wrap-functions
  :load-path "~/projects/emacs/pretty-org-tables"
  :bind (("C-c p" . org-table-column-wrap-to-point)
         ("C-c u" . org-table-unwrap-cell-region)))

(use-package olivetti
  :config
  (setq-default olivetti-body-width 82)
  ;; Auto‑enable in Org buffers
  (add-hook 'org-mode-hook #'olivetti-mode))


(use-package org-pretty-table
  :load-path "~/projects/emacs/pretty-org-tables/org-pretty-table.el"
  :hook (org-mode . org-pretty-table-mode))


(use-package org-journal
  :ensure t
  :custom
  (org-journal-dir "~/org/journal")
  (org-journal-file-format "%Y%m%d.org")
  (org-journal-date-format "%A, %d %B %Y")
  :bind
  ("C-c n j" . org-journal-new-entry))

;; Add to-do keywords and set their colors
(setq org-todo-keywords
      '((sequence "TODO" "WAIT" "INPROG" "|" "DONE" "DELEGATED")))

(setq org-todo-keyword-faces
      '(("TODO" :inherit org-todo :foreground "#A3BE8C" :weight bold)
        ("WAIT" :inherit org-todo :foreground "#CAC52F" :weight bold)
	("INPROG" :inherit org-todo :foreground "#8FBCBB" :weight bold)))

;; Insert link to non-existing org-roam note without displaying its buffer.
(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c n I") #'org-roam-node-insert-immediate))


;; Aggregated clocks for multiple timelog files.
(load-file "~/projects/emacs/aggregated-clocks/aggregated-clocks.el")


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


;; Debugging
(use-package dape
  :init
  (setq
   
   dape-configs
   '(
     (go-main ;; debug main .go file
      modes (go-mode)
      command "dlv"
      command-args ("dap" "--listen" "127.0.0.1::autoport")
                 command-cwd dape-command-cwd
                 port :autoport
                 :type "debug"
                 :request "launch"
                 :name "Debug Go Program"
                 :cwd "."
                 :program "."
                 :args []))))

;; Haskell
(use-package haskell-mode)
(let ((my-ghcup-path (expand-file-name "~/.ghcup/bin")))
  (setenv "PATH" (concat my-ghcup-path ":" (getenv "PATH")))
  (add-to-list 'exec-path my-ghcup-path))

;; Golang
(use-package go-mode
  :init
  (add-hook 'before-save-hook #'gofmt-before-save))

  




