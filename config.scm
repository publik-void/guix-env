(include "include/package-set-definitions.scm")
(include "include/service-set-definitions.scm")

;; TODO: Add a `desktop?` switch to remove desktop packages and services if `#f`

(home-environment
  (packages
    (append
      ;; TODO: resolve the `setuid` conflict
      ;;guix-base-package-set
      base-package-set
      fish-optional-dependencies-package-set
      tmux-optional-dependencies-package-set
      neovim-optional-dependencies-package-set
      encryption-package-set
      compression-package-set
      cxx-package-set
      writing-package-set
      python-package-set
      desktop-package-set
      (list console-setup)))
  (services
    (append
      service-set-common-resources
      service-set-common-resources-desktop
      service-set-git
      service-set-fish
      service-set-tmux
      service-set-neovim
      service-set-xmonad)))
