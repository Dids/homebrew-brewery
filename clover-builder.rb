class CloverBuilder < Formula
  desc "A command line application for building Clover"
  homepage "https://github.com/Dids/clover-builder-cli"
  url "https://github.com/Dids/clover-builder-cli/archive/987867fa9c4d8455a43eed2df1cd27525ac29368.tar.gz"
  sha256 "f146077e881b1812bff61cf67aa315165c5456e131919dc233bcd198145c57d8"
  #version "0.0.1"

  ## TODO: We technically require build tools too, so Xcode CLI tools should be required?

  # We need go for building
  depends_on "go" => :build

  # The rest are required for running
  depends_on "git"
  depends_on "svn"

  ## TODO: What is this?
  bottle :unneeded

  def install
    # Define GOPATH
    ENV["GOPATH"] = buildpath/"go"
    
    # Create the required directories
    (buildpath/"go/bin").mkpath
    (buildpath/"go/pkg").mkpath
    (buildpath/"go/src").mkpath
    (buildpath/"go/src/github.com/Dids").mkpath

    # Symlink the package directory
    ln_s buildpath, buildpath/"go/src/github.com/Dids/clover-builder-cli"

    # Install build dependencies
    system "cd", buildpath/"go/src/github.com/Dids/clover-builder-cli", "&&", "go", "get", "."

    # Build the application
    system "go", "build", "-o", buildpath/"clover-builder"
    bin.install buildpath/"clover-builder"
  end

  ## TODO: Properly test and implement this
  test do
    ## TODO: Also run go tests? Maybe? No?
    system bin/"clover-builder", "--help"
  end
end
