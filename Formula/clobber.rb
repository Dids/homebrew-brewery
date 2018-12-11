class Clobber < Formula
  desc "Command-line application for building Clover"
  homepage "https://github.com/Dids/clobber"
  url "https://github.com/Dids/clobber/archive/v0.1.6.tar.gz"
  sha256 "6ed7a518f0bc2b67e84c828c61167f6bd93bb0739d07d09cfe6524084bf5bb88"
  revision 0

  # Setup HEAD support (install with --HEAD)
  head "https://github.com/Dids/Clobber.git", :branch => "master"

  # No bottling necessary
  bottle :unneeded

  # We need dep for build dependencies
  depends_on "dep" => :build

  # We need go for building
  depends_on "go" => :build

  # We needs subversion for SVN support
  depends_on "subversion"
  
  # We need Xcode/xcodebuild for running the application
  depends_on :xcode

  # Define the installation steps
  def install
    # Define GOPATH
    ENV["GOPATH"] = buildpath/"go"

    # Create the required directory structure
    (buildpath/"go/bin").mkpath
    (buildpath/"go/pkg").mkpath
    (buildpath/"go/src").mkpath

    # Print out target version
    ohai "Building version #{version}.."

    # Build the application
    system "make", "deps"
    system "make", "build", "test", "BINARY_VERSION=#{version}"

    # Print the version
    system buildpath/"clobber", "--version"

    # Install the application
    bin.install buildpath/"clobber"

    # Test that the version matches
    if "clobber version #{version}" != `#{bin}/clobber --version`.strip
      odie "Output of 'clobber --version' did not match the current version (#{version})."
    end
  end

  test do
    # Test that the version matches
    assert_equal "clobber version #{version}", `#{bin}/clobber --version`.strip
  end
end
