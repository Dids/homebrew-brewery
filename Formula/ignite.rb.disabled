class Ignite < Formula
  desc "Ignition configuration tool for validation and merging multiple files"
  homepage "https://github.com/Dids/ignite"
  #url "https://github.com/Dids/ignite/archive/v0.0.1.tar.gz"
  #sha256 "60da164b6c52c413b1b0d60b539ecccfcaca44240361f3d118ef2b9e25131b69"
  #revision 0

  # Setup HEAD support (install with --HEAD)
  head "https://github.com/Dids/ignite.git", :branch => "master"

  # No bottling necessary
  bottle :unneeded

  # We need go for building
  depends_on "go" => :build

  # Define the installation steps
  def install
    # Define GOPATH
    ENV["GOPATH"] = buildpath/"go"
    ENV["GOBIN"] = buildpath/"go/bin"

    # Create the required directory structure
    (buildpath/"go/bin").mkpath
    (buildpath/"go/pkg").mkpath
    (buildpath/"go/src").mkpath
    (buildpath/"go/src/github.com/Dids/ignite").mkpath

    # Copy everything to the Go project directory (except the go/ folder)
    system "rsync -a ./ go/src/github.com/Dids/ignite/"

    # Switch to the Go project directory
    Dir.chdir 'go/src/github.com/Dids/ignite' do
      ohai "Switched to directory: #{Dir.pwd}"

      # Print out target version
      ohai "Building version #{version}.."

      # Build the application
      system "make", "deps"
      system "make", "build", "BINARY_VERSION=#{version}", "BINARY_OUTPUT=#{buildpath}/ignite"
      system "make", "test"

      # Install the application
      bin.install buildpath/"ignite"
    end
  end
end
