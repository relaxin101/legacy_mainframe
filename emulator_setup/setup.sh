rm -rf mvs-tk5
unzip mvs-tk5.zip
cd mvs-tk5
cp ../mvs_ipl .
chmod +x mvs_* unattended/set* hercules/darwin/bin/* hercules/darwin/lib/* hercules/darwin/lib/hercules/*
xattr -d com.apple.quarantine mvs_* unattended/set* hercules/darwin/bin/* hercules/darwin/lib/* hercules/darwin/lib/hercules/*
cd unattended
./set_console_mode
cd ..
./mvs_osx
