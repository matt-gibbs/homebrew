require 'formula'

class Nexus < Formula
  homepage 'http://www.sonatype.org/'
  url 'http://download.sonatype.com/nexus/oss/nexus-2.11.0-02-bundle.tar.gz'
  version '2.11.0-02'
  sha1 '57a9414907574ee3d35a684f7a1b31469e1853e7'

  def install
    rm_f Dir['bin/*.bat']
    # Put the sonatype-work directory in the var directory, to persist across version updates
    inreplace "nexus-#{version}/conf/nexus.properties",
      'nexus-work=${bundleBasedir}/../sonatype-work/nexus',
      "nexus-work=#{var}/nexus"
    libexec.install Dir["nexus-#{version}/*"]
    bin.install_symlink libexec/'bin/nexus'
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/nexus/libexec/bin/nexus start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>com.sonatype.nexus</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/nexus</string>
          <string>start</string>
        </array>
        <key>RunAtLoad</key>
      <true/>
      </dict>
    </plist>
    EOS
  end
end
