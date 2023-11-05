(use-modules
  (gnu home services)
  (gnu home services shells)
  (guix git))

(include "env-definitions.scm")

(home-environment
  (packages
    (transform
      (append guix-base-env
              base-env
              fish-optional-dependencies-env
              tmux-optional-dependencies-env
              neovim-optional-dependencies-env
              guix-env
              encryption-env
              compression-env
              cxx-env
              writing-env
              python-env
              desktop-env)))
  (services
    (list
      ;;(service home-bash-service-type
      ;;  (home-bash-configuration))
      ;;(service home-fish-service-type
      ;;  (home-fish-configuration (config (list (local-file "link-config.fish")))))
      ;;(service home-files-service-type `(
      ;;  (".gitconfig" ,(local-file "./.gitconfig" "gitconfig"))))
      ;;(service home-xdg-configuration-files-service-type `(
      ;;;; NOTE: At the time of writing this, the fish service won't build when
      ;;;; the `.config/fish` directory gets populated by another service
      ;;  ("config-fish" ,(git-checkout
      ;;    (url "https://github.com/publik-void/config-fish.git")))
      ;;  ("tmux" ,(git-checkout
      ;;    (url "https://github.com/publik-void/config-tmux.git")))
      ;;  ("nvim" ,(git-checkout
      ;;    (url "https://github.com/publik-void/config-nvim.git")))
      ;;  ("xmonad" ,(git-checkout
      ;;    (url "https://github.com/publik-void/config-xmonad.git")))
      ;;  ("cross-platform-copy-paste" ,(git-checkout
      ;;    (url "https://github.com/publik-void/cross-platform-copy-paste.git")))))
      )))
