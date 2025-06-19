include ./make.in

all: $(OUTPUTS) 

$(BUILD_FOLDER)/%.pdf: $(SRC_FOLDER)/%.tex
	$(TEX) $(TEX_OPTIONS) $<

$(PNG_FOLDER)/%.png: $(BUILD_FOLDER)/%.pdf
	$(CONVERT) -units pixelsperinch -density $(CONVERT_DENSITY) -quality 100 $<  $@

$(ICO_FOLDER)/%.ico: $(PNG_FOLDER)/%.png
	$(CONVERT) -background transparent $< -define icon:auto-resize=64 $@

clean:
	rm -rf $(BUILD_FOLDER)/*
