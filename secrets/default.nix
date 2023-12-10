{ ... }: {
  age.secrets = {
    file = ./atuin.age;

    owner = "tomas";
    group = "users";
  };
}
