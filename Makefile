BIN         = urn-gtk
OBJS        = urn.o urn-gtk.o bind.o $(COMPONENTS)
COMPONENTS  = $(addprefix components/, \
              urn-component.o title.o splits.o timer.o \
              prev-segment.o best-sum.o pb.o wr.o)

LIBS        = gtk+-3.0 x11 jansson
CFLAGS      += `pkg-config --cflags $(LIBS)` -Wall -Wno-unused-parameter -std=gnu99
LDLIBS      += `pkg-config --libs $(LIBS)`

PREFIX      = /usr/local
BIN_DIR     = $(PREFIX)/bin
APP         = urn.desktop
DATADIR     = $(PREFIX)/share
APP_DIR     = $(DATADIR)/applications
ICON        = urn.png
ICON_DIR    = $(DATADIR)/icons/hicolor
SCHEMAS_DIR = $(DATADIR)/glib-2.0/schemas

$(BIN): $(OBJS)

install:
	install -Dm755 $(BIN) $(BIN_DIR)/$(BIN)
	install -Dm644 $(APP) $(APP_DIR)/$(APP)
	for size in 16 22 24 32 36 48 64 72 96 128 256 512; do \
	  mkdir -p $(ICON_DIR)/"$$size"x"$$size"/apps ; \
	  magick static/$(ICON) -resize "$$size"x"$$size" \
	          $(ICON_DIR)/"$$size"x"$$size"/apps/$(ICON) ; \
	done
	gtk-update-icon-cache -f -t $(ICON_DIR)
	install -Dm644 urn-gtk.gschema.xml $(SCHEMAS_DIR)/urn-gtk.gschema.xml
	glib-compile-schemas $(SCHEMAS_DIR)
	mkdir -p $(DATADIR)/urn/themes
	cp -r themes $(DATADIR)/urn

uninstall:
	rm -f $(BIN_DIR)/$(BIN)
	rm -f $(APP_DIR)/$(APP)
	rm -rf $(DATADIR)/urn
	rm -f $(SCHEMAS_DIR)/urn-gtk.gschema.xml
	rm -f $(SCHEMAS_DIR)/gschemas.compiled
	for size in 16 22 24 32 36 48 64 72 96 128 256 512; do \
	  rm -f $(ICON_DIR)/"$$size"x"$$size"/apps/$(ICON) ; \
	done

remove-schema:
	rm $(SCHEMAS_DIR)/urn-gtk.gschema.xml
	glib-compile-schemas $(SCHEMAS_DIR)

clean:
	rm -f $(OBJS) $(BIN)
