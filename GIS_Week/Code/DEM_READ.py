registry = QgsProviderRegistry.instance()
provider = registry.provider("gdal", "e10g")

extent = provider.extent()
width = provider.xSize()
height = provider.ySize()

no_data_value = provider.srcNoDataValue(1)
histogram = {}
block = provider.block(1, extent, width, height)

for x in range(width):
    for y in range(height):
        elevation = block.value(x, y)
        
        if elevation == no_data_value: continue
        
        try:
            histogram[elevation] += 1
        except KeyError:
            histogram[elevation] = 1
            
for height in sorted(histogram.keys()):
    print (height, histogram[height])

