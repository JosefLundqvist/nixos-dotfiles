{ ... }:
{
  services.kanata = {
    enable = true;
    keyboards.default = {
      # Auto-detect keyboards, including Hyper-V's synthetic console keyboard.
      devices = [ ];
      extraDefCfg = "process-unmapped-keys yes";
      config = ''
        ;; Port of Default.ahk; output chords assume the US keyboard layout.
        (defsrc
          caps
          1 2 3 4 5 6 7 8 9 0 = [ ]
          lsft rsft
        )

        ;; Check physical Shift, so a symbol's generated Shift cannot select
        ;; the shifted mapping of the next key during overlapping key presses.
        (deftemplate shift-pair (plain shifted)
          (switch
            ((input real lsft) (input real rsft)) $shifted break
            () $plain break
          )
        )

        ;; Remove only Shift for unshifted outputs, retaining Ctrl/Alt/Super.
        (defalias
          one   (template-expand shift-pair S-1 (unshift 1))
          two   (template-expand shift-pair (unshift [) (unshift 2))
          three (template-expand shift-pair S-[ (unshift 3))
          four  (template-expand shift-pair S-9 (unshift 4))
          five  (template-expand shift-pair S-7 (unshift 5))
          six   (template-expand shift-pair (unshift =) (unshift 6))
          seven (template-expand shift-pair S-0 (unshift 7))
          eight (template-expand shift-pair S-] (unshift 8))
          nine  (template-expand shift-pair (unshift ]) (unshift 9))
          zero  (template-expand shift-pair S-8 (unshift 0))
          equal (template-expand shift-pair S-5 S-=)
          left-bracket  (template-expand shift-pair S-4 S-6)
          right-bracket (template-expand shift-pair S-2 S-3)
        )

        (deflayer default
          lctl
          @one @two @three @four @five @six @seven @eight @nine @zero
          @equal @left-bracket @right-bracket
          lsft rsft
        )
      '';
    };
  };
}
