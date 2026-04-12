{
  ...
}:

{
  # Add new machines here when I'm done configuring them and update other configs
  services.syncthing = {
    enable = true;
    settings = {
      devices = {
        # Phone (introducer, since its config isn't managed by Nix anyways)
        ginger = {
          id = "ROA5SZQ-OA33NRK-2NNBO5R-QVVW3FQ-DBFUWP6-XTQ4UKJ-M2D66T6-UAFPFAQ";
          introducer = true;
        };

        # DigitalOcean server
        sumac.id = "AY7LJTM-F5BRYPE-FDCXAGE-AJLP7TU-JW3PRMX-L6HX754-CK3MUGZ-KLEJWAB";

        # Laptop
        saffron.id = "T2F7ICT-EMNBQH6-TBDQ4DE-7X7J57J-QCGWIS2-VXBN4HB-LRGNZUZ-AFI5IQF";
      };
      folders."~/0everything" = {
        id = "0everything";
        devices = [
          "ginger"
          "sumac"
          "saffron"
        ];
      };
    };
  };
}
