class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v0.17.17",
      :revision => "54cbda80c19b499387b07ad7a8856817c3e19c29"

  bottle do
    cellar :any_skip_relocation
    sha256 "1faff15a8615358cd31442dea64b681027e426b75ec1e6e6eb210f9cf486f786" => :mojave
    sha256 "37be9bfab1c8474161827561e9b3ef29017b6c89953c8d20633b098ecd31b880" => :high_sierra
    sha256 "86a62cff32a36106108d0050b2e518b8347f5483409511d414171b4e1bdfa938" => :sierra
    sha256 "84a497b2fb6bcbf522c0912e465aae26e45c06184983f3661c386e8231be6eb7" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/pulumi/pulumi"
    dir.install buildpath.children

    cd dir do
      system "go", "mod", "vendor"
      system "make", "dist"
      bin.install Dir["#{buildpath}/bin/*"]
      prefix.install_metafiles

      # Install bash completion
      output = Utils.popen_read("#{bin}/pulumi gen-completion bash")
      (bash_completion/"pulumi").write output

      # Install zsh completion
      output = Utils.popen_read("#{bin}/pulumi gen-completion zsh")
      (zsh_completion/"_pulumi").write output
    end
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
