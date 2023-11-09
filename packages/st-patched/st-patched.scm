(use-modules
  (guix packages)
  (guix download)
  (gnu packages suckless))

(define st-patched
  (package
    (inherit st)
    (name "st-patched")
    (version "0.8.5")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://dl.suckless.org/st/st-" version ".tar.gz"))
       (sha256
        (base32 "0dxb8ksy4rcnhp5k54p7i7wwhm64ksmavf5wh90zfbyh7qh34s7a"))
       (patches
         (list
           (origin
             (method url-fetch)
             (uri "https://st.suckless.org/patches/bold-is-not-bright/st-bold-is-not-bright-20190127-3be4cf1.diff")
             (sha256
              (base32 "1cpap2jz80n90izhq5fdv2cvg29hj6bhhvjxk40zkskwmjn6k49j")))
           (origin
             (method url-fetch)
             (uri "https://st.suckless.org/patches/xresources/st-xresources-20200604-9ba7ecf.diff")
             (sha256
              (base32 "0nsda5q8mkigc647p1m8f5jwqn3qi8194gjhys2icxji5c6v9sav")))
           (local-file "files/st-patch-default-color-ordering.diff")))))))
