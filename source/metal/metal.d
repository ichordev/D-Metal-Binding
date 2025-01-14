module metal.metal;

version(D_ObjectiveC)
{
    extern(Objective-C):

    public import objc.runtime;
    import metal.library;
    import metal.vertexdescriptor;
    import metal.pixelformat;
    import metal.commandbuffer;
    import metal.texture;
    import metal.blitcommandencoder;



    enum MTLCPUCacheMode : NSUInteger
    {
        DefaultCache = 0,
        WriteCombined = 1
    }

    immutable NSUInteger MTLResourceCPUCacheModeShift = 0;
    immutable NSUInteger MTLResourceCPUCacheModeMask = 0xf << MTLResourceCPUCacheModeShift;
    immutable NSUInteger MTLResourceStorageModeShift = 4;
    immutable NSUInteger MTLResourceStorageModeMask = 0xf << MTLResourceStorageModeShift;
    immutable NSUInteger MTLResourceHazardTrackingModeShift = 8;
    immutable NSUInteger MTLResourceHazardTrackingModeMask = 0x3 << MTLResourceHazardTrackingModeShift;

    enum MTLStorageMode : NSUInteger
    {
        ///The resource is stored in system memory and is accessible to both the CPU and the GPU.
        Shared = 0,
        ///The CPU and GPU may maintain separate copies of the resource, and any changes must be explicitly synchronized.
        Managed = 1,
        ///The resource can be accessed only by the GPU.
        Private = 2,
        ///The resource’s contents can be accessed only by the GPU and only exist temporarily during a render pass.
        Memoryless
    }

    enum MTLHazardTrackingMode : NSUInteger
    {
        ///An option specifying that the default tracking mode should be used.
        Default = 0,
        ///An option specifying that the app must prevent hazards when modifying this object's contents.
        Untracked = 1,
        ///An option specifying that Metal prevents hazards when modifying this object's contents.
        Tracked = 2
    }

    ///Optional arguments used to set the behavior of a resource.
    enum MTLResourceOptions : NSUInteger
    {
        ///The default CPU cache mode for the resource, which guarantees that read and write operations are executed in the expected order.
        DefaultCache = MTLCPUCacheMode.DefaultCache  << MTLResourceCPUCacheModeShift,
        ///A write-combined CPU cache mode that is optimized for resources that the CPU writes into, but never reads.
        CPUCacheModeWriteCombined = MTLCPUCacheMode.WriteCombined << MTLResourceCPUCacheModeShift,
        ///The resource is stored in system memory and is accessible to both the CPU and the GPU.
        StorageModeShared = MTLStorageMode.Shared << MTLResourceStorageModeShift,
        ///The CPU and GPU may maintain separate copies of the resource, which you need to explicitly synchronize.
        StorageModeManaged = MTLStorageMode.Managed << MTLResourceStorageModeShift,
        ///The resource can be accessed only by the GPU.
        StorageModePrivate = MTLStorageMode.Private << MTLResourceStorageModeShift,
        ///The resource’s contents can be accessed only by the GPU and only exist temporarily during a render pass.
        StorageModeMemoryless = MTLStorageMode.Memoryless << MTLResourceStorageModeShift,
        ///An option specifying that the default tracking mode should be used.
        HazardTrackingModeDefault = MTLHazardTrackingMode.Default << MTLResourceHazardTrackingModeShift,
        ///An option specifying that Metal prevents hazards when modifying this object's contents.
        HazardTrackingModeTracked = MTLHazardTrackingMode.Tracked << MTLResourceHazardTrackingModeShift,
        ///An option specifying that the app must prevent hazards when modifying this object's contents.
        HazardTrackingModeUntracked = MTLHazardTrackingMode.Untracked << MTLResourceHazardTrackingModeShift,
    }

    ///The coordinates for the front upper-left corner of a region.
    struct MTLOrigin
    {
        NSUInteger x, y, z;
    }
    ///Returns a new origin with the specified coordinates.
    extern(C) MTLOrigin MTLOriginMake(NSUInteger x, NSUInteger y, NSUInteger z);

    struct MTLRegion
    {
        ///The coordinates of the front upper-left corner of the region.
        MTLOrigin origin;
        ///The dimensions of the region.
        MTLSize size;
    }

    
    extern interface MTLRenderPipelineState
    {
        MTLDevice device() @selector("device");
        NSString label() @selector("label");

    }

    enum MTLTriangleFillMode : NSUInteger
    {
        ///Rasterize triangle and triangle strip primitives as filled triangles.
        Fill = 0,
        ///Rasterize triangle and triangle strip primitives as lines.
        Lines = 1
    }

    enum MTLWinding : NSUInteger
    {
        ///Primitives whose vertices are specified in clockwise order are front-facing.
        Clockwise = 0,
        ///Primitives whose vertices are specified in counter-clockwise order are front-facing.
        CounterClockwise = 1
    }
    
    struct MTLViewport
    {
        double originX = 0;
        double originY = 0;
        double width = 0;
        double height = 0;
        double znear = 0;
        double zfar = 0;
    }

    enum MTLCullMode : NSUInteger
    {
        ///Does not cull any primitives.
        None = 0,
        ///Culls front-facing primitives.
        Front = 1,
        ///Culls back-facing primitives.
        Back = 2
    }

    extern class MTLFunction
    {

    }

    struct MTLClearColor
    {
        float red, green, blue, alpha;
    }

    MTLClearColor MTLClearColorMake(double red = 0.0, double green = 0.0, double blue = 0.0, double alpha = 1.0);

    extern class MTLRenderPassAttachmentDescriptor : NSObject
    {
    }
    
    ///Types of actions performed for an attachment at the start of a rendering pass.
    enum MTLLoadAction: NSUInteger
    {
        ///The GPU has permission to discard the existing contents of the attachment at the start of the render pass, replacing them with arbitrary data.
        DontCare = 0,
        ///The GPU preserves the existing contents of the attachment at the start of the render pass.
        Load = 1,
        ///The GPU writes a value to every pixel in the attachment at the start of the render pass.
        Clear = 2,
    }
    
    ///Types of actions performed for an attachment at the end of a rendering pass.
    enum MTLStoreAction: NSUInteger
    {
        ///The GPU has permission to discard the rendered contents of the attachment at the end of the render pass, replacing them with arbitrary data.
        DontCare = 0,
        ///The GPU stores the rendered contents to the texture.
        Store = 1,
        ///The GPU resolves the multisampled data to one sample per pixel and stores the data to the resolve texture, discarding the multisample data afterwards.
        MultisampleResolve = 2,
        ///The GPU stores the multisample data to the multisample texture, resolves the data to a sample per pixel, and stores the data to the resolve texture.
        StoreAndMultisampleResolve = 3,
        ///The app will specify the store action when it encodes the render pass.
        Unknown = 4,
        ///The GPU stores depth data in a sample-position–agnostic representation.
        CustomSampleDepthStore,
    }

    extern class MTLRenderPassColorAttachmentDescriptor : MTLRenderPassAttachmentDescriptor
    {
        ///The color to use when clearing the color attachment.
        @selector("clearColor")
        MTLClearColor clearColor();
        @selector("setClearColor:")
        MTLClearColor clearColor(MTLClearColor);
        
        @selector("texture")
        MTLTexture texture();
        @selector("setTexture:")
        MTLTexture texture(MTLTexture);
        
        @selector("loadAction")
        MTLLoadAction loadAction();
        @selector("setLoadAction:")
        MTLLoadAction loadAction(MTLLoadAction);
        
        @selector("storeAction")
        MTLStoreAction storeAction();
        @selector("setStoreAction:")
        MTLStoreAction storeAction(MTLStoreAction);
    }

    extern class MTLRenderPassColorAttachmentDescriptorArray : NSObject
    {
        @selector("setObject:atIndexedSubscript:")
        void setObjectAtIndexedSubscript(MTLRenderPassColorAttachmentDescriptor attachment, NSUInteger attachmentIndex);

        @selector("objectIndexedAtSubscript:")
        MTLRenderPassColorAttachmentDescriptor objectIndexedAtSubscript(NSUInteger attachmentIndex);

        MTLRenderPassColorAttachmentDescriptor opIndex(NSUInteger index)
        {
            return objectIndexedAtSubscript(index);
        }

        void opIndexAssign(MTLRenderPassColorAttachmentDescriptor attachment, NSUInteger index)
        {
            setObjectAtIndexedSubscript(attachment, index);
        }
    }

    enum MTLMultisampleDepthResolveFilter : NSUInteger
    {
        ///No filter is applied.
        Sample0 = 0,
        ///The GPU compares all depth samples in the pixel and selects the sample with the smallest value.
        Min,
        ///The GPU compares all depth samples in the pixel and selects the sample with the largest value.
        Max
    }
    extern class MTLRenderPassDepthAttachmentDescriptor : MTLRenderPassAttachmentDescriptor
    {
        double clearDepth = 1.0;
        MTLMultisampleDepthResolveFilter depthResolveFilter = MTLMultisampleDepthResolveFilter.Sample0;
    }

    enum MTLMultisampleStencilResolveFilter : NSUInteger
    {
        Sample0 = 0,
        DepthResolvedSample = 1
    }
    extern class MTLRenderPassStencilAttachmentDescriptor : MTLRenderPassAttachmentDescriptor
    {
        MTLMultisampleStencilResolveFilter stencilResolveFilter = MTLMultisampleStencilResolveFilter.Sample0;
        uint clearStencil;
    }

    struct MTLSize
    {
        NSUInteger width;
        NSUInteger height;
        NSUInteger depth;
    }
    struct MTLSizeAndAlign
    {
        NSUInteger size;
        NSUInteger align_;
    }

    struct MTLSamplePosition
    {
        float x;
        float y;
    }

    enum MTLPrimitiveType : NSUInteger
    {
        ///Rasterize a point at each vertex. The vertex shader must provide [[point_size]], or the point size is undefined.
        Point = 0,
        ///Rasterize a line between each separate pair of vertices, resulting in a series of unconnected lines. If there are an odd number of vertices, the last vertex is ignored.
        Line = 1,
        ///Rasterize a line between each pair of adjacent vertices, resulting in a series of connected lines (also called a polyline).
        LineStrip = 2,
        ///For every separate set of three vertices, rasterize a triangle. If the number of vertices is not a multiple of three, either one or two vertices is ignored.
        Triangle = 3,
        ///For every three adjacent vertices, rasterize a triangle.
        TriangleStrip
    }

    enum MTLIndexType : NSUInteger
    {
        ///A 16-bit unsigned integer used as a primitive index.
        UInt16 = 0,
        ///A 32-bit unsigned integer used as a primitive index.
        UInt32 = 1
    }
   
    interface MTLCounterSampleBuffer
    {
        ///Transforms samples of a GPU’s counter set from the driver’s internal format to a standard Metal data structure.
        @selector("resolveCounterRange:")
        NSData resolveCounterRange(NSRange range);
    }

    alias MTLCoordinate2D = MTLSamplePosition;

    MTLSize MTLSizeMake(NSUInteger width, NSUInteger height, NSUInteger depth);
    MTLCoordinate2D MTLCoordinate2DMake(float x, float y);

    extern interface MTLRasterizationRateMap
    {
        ///The device object that created the rate map.
        MTLDevice device() @selector("device");
        ///A string that identifies the rate map.
        NSString label() @selector("label");
        ///The number of layers in the rate map.
        NSUInteger layerCount() @selector("layerCount");
        ///The logical size, in pixels, of the viewport coordinate system.
        MTLSize screenSize() @selector("screenSize");

        ///Returns the dimensions, in pixels, of the area in the render target affected by the rasterization rate map.
        @selector("physicalSizeForLayer:")
        MTLSize physicalSizeForLayer(NSUInteger layerIndex);

        ///The granularity, in physical pixels, at which the rasterization rate varies.
        MTLSize physicalGranularity() @selector("physicalGranularity");

        ///Converts a point in logical viewport coordinates to the corresponding physical coordinates in a render layer.
        @selector("mapScreenToPhysicalCoordinates:forLayer:")
        MTLCoordinate2D mapScreenToPhysicalCoordinates(MTLCoordinate2D screenCoordinates, NSUInteger layerIndex);

        ///Converts a point in physical coordinates inside a layer to its corresponding logical viewport coordinates.
        @selector("mapPhysicalToScreenCoordinates:forLayer:")
        MTLCoordinate2D mapPhysicalToScreenCoordinates(MTLCoordinate2D physicalCoordinates, NSUInteger layerIndex);

        ///The size and alignment requirements to contain the coordinate transformation information in this rate map.
        @selector("parameterBufferSizeAndAlign")
        MTLSizeAndAlign parameterBufferSizeAndAlign();
        
        ///Copies the parameter data into the provided buffer.
        @selector("copyParameterDataToBuffer:offset:")
        void copyParameterDataToBuffer(MTLBuffer buffer, NSUInteger offset);


    }

   

    ///A description of where to store GPU counter information at the start and end of a render pass.
    extern class MTLRenderPassSampleBufferAttachmentDescriptor : NSObject
    {
        ///The sample buffer to write new GPU counter samples to.
        @selector("sampleBuffer")
        MTLCounterSampleBuffer sampleBuffer();
        @selector("setSampleBuffer:")
        MTLCounterSampleBuffer sampleBuffer(MTLCounterSampleBuffer sampleBuffer);

        ///The index the Metal device object should use to store GPU counters when starting the render pass’s vertex stage.
        @selector("startOfVertexSampleIndex")
        NSUInteger startOfVertexSampleIndex();
        @selector("setStartOfVertexSampleIndex:")
        NSUInteger startOfVertexSampleIndex(NSUInteger);

        ///The index the Metal device object should use to store GPU counters when ending the render pass’s vertex stage.
        @selector("endOfVertexSampleIndex")
        NSUInteger endOfVertexSampleIndex();
        @selector("setEndOfVertexSampleIndex:")
        NSUInteger endOfVertexSampleIndex(NSUInteger);

        ///The index the Metal device object should use to store GPU counters when starting the render pass’s fragment stage.
        @selector("startOfFragmentSampleIndex")
        NSUInteger startOfFragmentSampleIndex();
        @selector("setStartOfFragmentSampleIndex:")
        NSUInteger startOfFragmentSampleIndex(NSUInteger);

        ///The index the Metal device object should use to store GPU counters when ending the render pass’s fragment stage.
        @selector("endOfFragmentSampleIndex")
        NSUInteger endOfFragmentSampleIndex();
        @selector("setEndOfFragmentSampleIndex:")
        NSUInteger endOfFragmentSampleIndex(NSUInteger);

        
    }

    extern class MTLRenderPassSampleBufferAttachmentDescriptorArray : NSObject
    {
        ///Returns the descriptor object for the specified sample buffer attachment.
        @selector("objectAtIndexedSubscript:")
        MTLRenderPassSampleBufferAttachmentDescriptor objectAtIndexedSubscript(NSUInteger attachmentIndex);

        ///Sets the descriptor object for the specified sample buffer attachment.
        @selector("setObject:atIndexedSubscript:")
        void setObjectAtIndexedSubscript(MTLRenderPassSampleBufferAttachmentDescriptor attachment, NSUInteger attachmentIndex);
    }

    ///A group of render targets that hold the results of a render pass.
    extern class MTLRenderPassDescriptor
    {
        @selector("new")
        static MTLRenderPassDescriptor new_();
        
        ///Creates a default render pass descriptor.
        @selector("renderPassDescriptor")
        static MTLRenderPassDescriptor renderPassDescriptor();

        ///An array of state information for attachments that store color data.
        @selector("colorAttachments")
        MTLRenderPassColorAttachmentDescriptorArray colorAttachments();

        ///State information for an attachment that stores depth data.
        @selector("depthAttachment")
        MTLRenderPassDepthAttachmentDescriptor depthAttachment();
        @selector("setDepthAttachment:")
        MTLRenderPassDepthAttachmentDescriptor depthAttachment(MTLRenderPassDepthAttachmentDescriptor);
        
        ///State information for an attachment that stores stencil data.
        @selector("stencilAttachment")
        MTLRenderPassStencilAttachmentDescriptor stencilAttachment();
        @selector("setStencilAttachment:")
        MTLRenderPassStencilAttachmentDescriptor stencilAttachment(MTLRenderPassStencilAttachmentDescriptor);

        ///A buffer where the GPU writes visibility test results when fragments pass depth and stencil tests.
        @selector("visibilityResultBuffer")
        MTLBuffer visibilityResultBuffer();
        @selector("setVisibilityResultBuffer:")
        MTLBuffer visibilityResultBuffer(MTLBuffer);

        ///The number of active layers that all attachments must have for layered rendering.
        @selector("renderTargetArrayLength")
        NSUInteger renderTargetArrayLength();
        @selector("setRenderTargetArrayLength:")
        NSUInteger renderTargetArrayLength(NSUInteger);

        /// The width, in pixels, to constrain the render target to.
        @selector("renderTargetWidth")
        NSUInteger renderTargetWidth();
        @selector("setRenderTargetWidth:")
        NSUInteger renderTargetWidth(NSUInteger);

        ///The height, in pixels, to constrain the render target to.
        @selector("renderTargetHeight")
        NSUInteger renderTargetHeight();
        @selector("setRenderTargetHeight:")
        NSUInteger renderTargetHeight(NSUInteger);


        ///Sets the programmable sample positions for a render pass.
        @selector("setSamplePositions:count:")
        void setSamplePositions(const MTLSamplePosition positions, NSUInteger count);

        @selector("getSamplePositions:count:")
        NSUInteger getSamplePositions(MTLSamplePosition positions, NSUInteger count);

        ///The per-sample size, in bytes, of the largest explicit imageblock layout in the render pass.
        @selector("imageBlockSampleLength")
        NSUInteger imageBlockSampleLength();
        @selector("setImageBlockSampleLength:")
        NSUInteger imageBlockSampleLength(NSUInteger);

        ///The per-tile size, in bytes, of the persistent threadgroup memory allocation.
        @selector("threadgroupMemoryLength")
        NSUInteger threadgroupMemoryLength();
        @selector("setThreadgroupMemoryLength:")
        NSUInteger threadgroupMemoryLength(NSUInteger);

        ///The tile width, in pixels.
        @selector("tileWidth")
        NSUInteger tileWidth();
        @selector("setTileWidth:")
        NSUInteger tileWidth(NSUInteger);


        ///The tile height, in pixels.
        @selector("tileHeight")
        NSUInteger tileHeight();
        @selector("setTileHeight:")
        NSUInteger tileHeight(NSUInteger);

        ///The raster sample count for the render pass when the render pass doesn’t have explicit attachments.
        @selector("defaultRasterSampleCount")
        NSUInteger defaultRasterSampleCount();
        @selector("setDefaultRasterSampleCount:")
        NSUInteger defaultRasterSampleCount(NSUInteger);

        ///The rasterization rate map to use when executing the render pass.
        @selector("rasterizationRateMap")
        MTLRasterizationRateMap rasterizationRateMap();
        @selector("setRasterizationRateMap:")
        MTLRasterizationRateMap rasterizationRateMap(MTLRasterizationRateMap);

        ///The array of sample buffers that the render pass can access.
        @selector("sampleBufferAttachments")
        MTLRenderPassSampleBufferAttachmentDescriptorArray sampleBufferAttachments();

    }

   

    enum MTLColorWriteMask : NSUInteger
    {
        None = 0,
        Red = 0x1 << 3,
        Green = 0x1 << 2,
        Blue = 0x1 << 1,
        Alpha = 0x1 << 0,
        All = 0xf
    }

    enum MTLBlendOperation : NSUInteger
    {
        ///Add portions of both source and destination pixel values.
        Add = 0,
        ///Subtract a portion of the destination pixel values from a portion of the source.
        Subtract = 1,
        ///Subtract a portion of the source values from a portion of the destination pixel values.
        ReverseSubtract = 2,
        ///Minimum of the source and destination pixel values.
        Min = 3,
        ///Maximum of the source and destination pixel values.
        Max = 4
    }

    enum MTLBlendFactor : NSUInteger
    {
        Zero = 0,
        One = 1,
        ///Blend factor of source values.
        SourceColor = 2,
        ///Blend factor of one minus source values.
        OneMinusSourceColor = 3,
        ///Blend factor of source alpha.
        SourceAlpha = 4,
        ///Blend factor of one minus source alpha.
        OneMinusSourceAlpha = 5,
        ///Blend factor of destination values.
        DestinationColor = 6,
        ///Blend factor of one minus destination values.
        OneMinusDestinationColor = 7,
        ///Blend factor of one minus destination values.
        DestinationAlpha = 8,
        ///Blend factor of one minus destination alpha.
        OneMinusDestinationAlpha = 9,
        ///Blend factor of the minimum of either source alpha or one minus destination alpha.
        SourceAlphaSaturated = 10,
        ///Blend factor of RGB values.
        BlendColor = 11,
        ///Blend factor of one minus RGB values.
        OneMinusBlendColor = 12,
        ///Blend factor of alpha value.
        BlendAlpha = 13,
        ///Blend factor of one minus alpha value.
        OneMinusBlendAlpha = 14,
        ///Blend factor of source values. This option supports dual-source blending and reads from the second color output of the fragment function.
        Source1Color = 15,
        ///Blend factor of one minus source values. This option supports dual-source blending and reads from the second color output of the fragment function.
        OneMinusSource1Color = 16,
        ///Blend factor of source alpha. This option supports dual-source blending and reads from the second color output of the fragment function.
        Source1Alpha = 17,
        ///Blend factor of one minus source alpha. This option supports dual-source blending and reads from the second color output of the fragment function.
        OneMinusSource1Alpha = 18

    }

    extern class MTLRenderPipelineColorAttachmentDescriptor
    {
        ///The pixel format of the color attachment’s texture.
        @selector("pixelFormat")
        MTLPixelFormat pixelFormat();
        @selector("setPixelFormat:")
        MTLPixelFormat pixelFormat(MTLPixelFormat);

        ///A bitmask that restricts which color channels are written into the texture.
        @selector("writeMask")
        MTLColorWriteMask writeMask();
        @selector("setWriteMask:")
        MTLColorWriteMask writeMask(MTLColorWriteMask);

        ///A Boolean value that determines whether blending is enabled.
        @selector("blendingEnabled")
        BOOL isBlendingEnabled();
        @selector("setBlendingEnabled:")
        BOOL blendingEnabled(BOOL);

        ///The blend operation assigned for the alpha data.
        @selector("alphaBlendOperation")
        MTLBlendOperation alphaBlendOperation();
        @selector("setAlphaBlendOperation:")
        MTLBlendOperation alphaBlendOperation(MTLBlendOperation);

        ///The blend operation assigned for the RGB data.
        @selector("rgbBlendOperation")
        MTLBlendOperation rgbBlendOperation();
        @selector("setRgbBlendOperation:")
        MTLBlendOperation rgbBlendOperation(MTLBlendOperation);

        ///The destination blend factor (DBF) used by the alpha blend operation.
        @selector("destinationAlphaBlendFactor")
        MTLBlendFactor destinationAlphaBlendFactor();
        @selector("setDestinationAlphaBlendFactor:")
        MTLBlendFactor destinationAlphaBlendFactor(MTLBlendFactor);

        ///The destination blend factor (DBF) used by the RGB blend operation.
        @selector("destinationRGBBlendFactor")
        MTLBlendFactor destinationRGBBlendFactor();
        @selector("setDestinationRGBBlendFactor:")
        MTLBlendFactor destinationRGBBlendFactor(MTLBlendFactor);

        ///The source blend factor (SBF) used by the alpha blend operation.
        @selector("sourceAlphaBlendFactor")
        MTLBlendFactor sourceAlphaBlendFactor();
        @selector("setSourceAlphaBlendFactor:")
        MTLBlendFactor sourceAlphaBlendFactor(MTLBlendFactor);

        ///The source blend factor (SBF) used by the RGB blend operation.
        @selector("sourceRGBBlendFactor")
        MTLBlendFactor sourceRGBBlendFactor();
        @selector("setSourceRGBBlendFactor:")
        MTLBlendFactor sourceRGBBlendFactor(MTLBlendFactor);




    }

    extern class MTLRenderPipelineColorAttachmentDescriptorArray : NSObject
    {
        override static MTLRenderPipelineColorAttachmentDescriptorArray alloc() @selector("alloc");
        override MTLRenderPipelineColorAttachmentDescriptorArray initialize() @selector("init");
        alias ini = initialize;

        @selector("setObject:atIndexedSubscript:")
        void setObjectAtIndexedSubscript(MTLRenderPipelineColorAttachmentDescriptor attachment, NSUInteger attachmentIndex);

        @selector("objectAtIndexedSubscript:")
        MTLRenderPipelineColorAttachmentDescriptor objectAtIndexedSubscript(NSUInteger attachmentIndex);

        extern(D) final MTLRenderPipelineColorAttachmentDescriptor opIndex(NSUInteger index)
        {
            return objectAtIndexedSubscript(index);
        }
        extern(D) final void opIndexAssign(NSUInteger index, MTLRenderPipelineColorAttachmentDescriptor v)
        {
            setObjectAtIndexedSubscript(v, index);
        }
    }

    extern class MTLRenderPipelineDescriptor : NSObject
    {
        // mixin ObjectiveCOpCall;
        override static MTLRenderPipelineDescriptor alloc() @selector("alloc");
        override MTLRenderPipelineDescriptor initialize() @selector("init");
        alias ini = initialize;

        ///A string that identifies the render pipeline descriptor.
        NSString label() @selector("label");
        NSString label(NSString) @selector("setLabel:");

        ///The vertex function the pipeline calls to process vertices.
        MTLFunction vertexFunction() @selector("vertexFunction");
        MTLFunction vertexFunction(MTLFunction) @selector("setVertexFunction:");

        ///The fragment function the pipeline calls to process fragments.
        MTLFunction fragmentFunction() @selector("fragmentFunction");
        MTLFunction fragmentFunction(MTLFunction) @selector("setFragmentFunction:");

        ///The organization of vertex data in an attribute’s argument table.
        MTLVertexDescriptor vertexDescriptor() @selector("vertexDescriptor");
        MTLVertexDescriptor vertexDescriptor(MTLVertexDescriptor) @selector("setVertexDescriptor:");


        ///An array of attachments that store color data.
        MTLRenderPipelineColorAttachmentDescriptorArray colorAttachments() @selector("colorAttachments");

        ///The pixel format of the attachment that stores depth data.
        MTLPixelFormat depthAttachmentPixelFormat() @selector("depthAttachmentPixelFormat");
        MTLPixelFormat depthAttachmentPixelFormat(MTLPixelFormat) @selector("setDepthAttachmentPixelFormat:");

        ///The pixel format of the attachment that stores stencil data.
        MTLPixelFormat stencilAttachmentPixelFormat() @selector("stencilAttachmentPixelFormat");
        MTLPixelFormat stencilAttachmentPixelFormat(MTLPixelFormat) @selector("setStencilAttachmentPixelFormat:");

        
    }
    interface MTLIOCommandQueue
    {

    }

    extern class MTLIOCommandQueueDescriptor : NSObject
    {

    }

    ///The render stages at which a synchronization command is triggered.
    enum MTLRenderStages : NSUInteger
    {
        ///The vertex rendering stage.
        Vertex = 1 << 0,
        ///The fragment rendering stage.
        Fragment = 1 << 1,
        ///The tile rendering stage.
        Tile = 1 << 2,
        Mesh = 1 << 4,
        Object = 1 << 3
    }

    ///An object that can capture, track, and manage resource dependencies across command encoders.
    extern interface MTLFence
    {
        ///The device object that created the fence.
        @selector("device")
        MTLDevice device();

        ///A string that identifies the fence.
        @selector("label")
        NSString label();

        @selector("setLabel:")
        NSString label(NSString);

    }
    

    extern class MTLDevice
    {

        ///Creates a queue you use to submit rendering and computation commands to a GPU.
        @selector("newCommandQueue")
        MTLCommandQueue newCommandQueue();

        ///Creates a queue you use to submit rendering and computation commands to a GPU that has a fixed number of uncompleted command buffers.
        @selector("newCommandQueueWithMaxCommandBufferCount:")
        MTLCommandQueue newCommandQueue(NSUInteger maxCommandBufferCount);

        ///Creates a buffer the method clears with zero values, length is size in bytes.
        @selector("newBufferWithLength:options:")
        MTLBuffer newBuffer(NSUInteger length, MTLResourceOptions options);

        ///Allocates a new buffer of a given length and initializes its contents by copying existing data into it.
        @selector("newBufferWithBytes:length:options:")
        MTLBuffer newBuffer(const(void)* pointer, NSUInteger length, MTLResourceOptions options);

        ///Creates a new texture instance.
        @selector("newTextureWithDescriptor:")
        MTLTexture newTextureWithDescriptor(MTLTextureDescriptor descriptor);


        ///Synchronously creates a Metal library instance by compiling the functions in a source string.
        @selector("newLibraryWithSource:options:error:")
        MTLLibrary newLibraryWithSource(NSString source, MTLCompileOptions options, NSError* error = null);

        ///Creates a Metal library instance that contains the functions from your app’s default Metal library.
        @selector("newDefaultLibrary")
        MTLLibrary newDefaultLibrary();

        ///Creates a new memory fence instance.
        @selector("newFence")
        MTLFence newFence();


        ///Creates an input/output command queue you use to submit commands that load assets from the file system into GPU resources or system memory.
        @selector("newIOCommandQueueWithDescriptor:error:")
        MTLIOCommandQueue newIOCommandQueueWithDescriptor(MTLIOCommandQueueDescriptor descriptor, NSError* error = null);

        ///Synchronously creates a render pipeline state.
        @selector("newRenderPipelineStateWithDescriptor:error:")
        MTLRenderPipelineState newRenderPipelineStateWithDescriptor(MTLRenderPipelineDescriptor descriptor, NSError* error = null);

        ///Returns a Boolean value that indicates whether the GPU can sample a texture with a specific number of sample points.
        @selector("supportsTextureSampleCount:")
        BOOL supportsTextureSampleCount(NSUInteger sampleCount);

        ///Creates a sampler state instance.
        @selector("newSamplerStateWithDescriptor:")
        MTLSamplerState newSamplerStateWithDescriptor(MTLSamplerDescriptor descriptor);

        ///Returns the minimum alignment the GPU device requires to create a texture buffer from a buffer.
        @selector("minimumTextureBufferAlignmentForPixelFormat:")
        NSUInteger minimumTextureBufferAlignmentForPixelFormat(MTLPixelFormat);

    }

    ///A block of code invoked after a drawable is presented.
    alias MTLDrawablePresentedHandler = extern(C) void function(MTLDrawable);



    ///A displayable resource that can be rendered or written to.
    extern interface MTLDrawable
    {
        ///A positive integer that identifies the drawable.
        @selector("drawableID")
        NSUInteger drawableID();

        ///Presents the drawable onscreen as soon as possible.
        @selector("present")
        void present();

        ///Presents the drawable onscreen at a specific host time.
        @selector("presentAtTime:")
        void present(CFTimeInterval presentationTime);

        ///Presents the drawable onscreen as soon as possible after a previous drawable is visible for the specified duration.
        @selector("presentAfterMinimumDuration:")
        void presentAfterMinimumDuration(CFTimeInterval duration);


        ///Registers a block of code to be called immediately after the drawable is presented.
        @selector("addPresentedHandler:")
        void addPresentedHandler(MTLDrawablePresentedHandler);

        ///The host time, in seconds, when the drawable was displayed onscreen.
        @selector("presentedTime")
        CFTimeInterval presentedTime();
    }


    MTLSamplePosition MTLSamplePositionMake(float x, float y);
    MTLCommandBuffer MTLCreateSystemDefaultDevice();

    ///An instance you use to create, submit, and schedule command buffers to a specific GPU device to run the commands within those buffers.
    extern interface MTLCommandQueue
    {
        ///Returns a command buffer from the command queue that you configure with a descriptor.
        @selector("commandBufferWithDescriptor:")
        MTLCommandBuffer commandBuffer(MTLCommandBufferDescriptor* descriptor);

        ///Returns a command buffer from the command queue that maintains strong references to resources.
        @selector("commandBuffer")
        MTLCommandBuffer commandBuffer();

        ///Returns a command buffer from the command queue that doesn’t maintain strong references to resources.
        @selector("commandBufferWithUnretainedReferences")
        MTLCommandBuffer commandBufferWithUnretainedReferences();

        ///The GPU device that creates the command queue.
        @selector("device")
        MTLDevice device();

        ///An optional name that can help you identify the command queue.
        @selector("label")
        NSString label();
        @selector("setLabel:")
        NSString label(NSString);
        
    }

    ///A Metal drawable associated with a Core Animation layer.
    extern interface CAMetalDrawable : MTLDrawable
    {
        ///A Metal texture object that contains the drawable’s contents.
        @selector("texture")
        MTLTexture texture();
        ///The layer that owns this drawable object.
        // @selector("layer")
        // CAMetalLayer layer();
    }

    ///An allocation of memory that is accessible to a GPU.
    extern interface MTLResource
    {
        ///The device object that created the resource.
        @selector("device")
        MTLDevice device();

        ///A string that identifies the resource.
        @selector("label")
        NSString label();
        @selector("setLabel:")
        NSString label(NSString);
    }
    
    ///An encoder that writes GPU commands into a command buffer.
    extern interface MTLCommandEncoder
    {
        ///Declares that all command generation from the encoder is completed.
        @selector("endEncoding")
        void endEncoding();

        ///Inserts a debug string into the captured frame data.
        @selector("insertDebugSignpost:")
        void insertDebugSignpost(NSString);

        ///Pushes a specific string onto a stack of debug group strings for the command encoder.
        @selector("pushDebugGroup:")
        void pushDebugGroup(NSString);

        ///Pops the latest string off of a stack of debug group strings for the command encoder.
        @selector("popDebugGroup")
        void popDebugGroup();

        ///The Metal device from which the command encoder was created.
        @selector("device")
        MTLDevice device();

        ///A string that labels the command encoder.
        @selector("label")
        NSString label();

        @selector("setLabel:")
        NSString label(NSString);
    }


    extern interface MTLBuffer
    {
        ///Creates a texture that shares its storage with the buffer.
        @selector("newTextureWithDescriptor:offset:bytesPerRow:")
        MTLTexture newTextureWithDescriptor(
            MTLTextureDescriptor,
            NSUInteger offset,
            NSUInteger bytesPerRow
        );


        ///Gets the system address of the buffer’s storage allocation.
        void* contents() @selector("contents");
        ///Informs the GPU that the CPU has modified a section of the buffer.
        void didModifyRange(NSRange) @selector("didModifyRange:");

        ///Adds a debug marker string to a specific buffer range.
        @selector("addDebugMarker:range:")
        void addDebugMarker(NSString marker, NSRange range);

        ///Removes all debug marker strings from the buffer.
        @selector("removeAllDebugMarkers")
        void removeAllDebugMarkers();

        ///The logical size of the buffer, in bytes.
        @selector("length")
        NSUInteger length();

        @selector("dealloc")
        void dealloc();
    }

    ///An object you use to synchronize access to Metal resources.
    extern interface MTLEvent
    {
        ///The device object that created the event.
        @selector("device")
        MTLDevice device();

        ///A string that identifies the event.
        @selector("label")
        NSString label();
    }

    extern class CALayer : NSObject
    {
    }

    extern class CAMetalLayer : CALayer
    {
        @selector("pixelFormat")
        MTLPixelFormat pixelFormat();
        @selector("setPixelFormat:")
        MTLPixelFormat pixelFormat(MTLPixelFormat);

        @selector("device")
        MTLDevice device();

        @selector("drawableSize")
        CGSize drawableSize();
        @selector("drawableSize:")
        CGSize drawableSize(CGSize);
        
        @selector("nextDrawable")
        CAMetalDrawable nextDrawable();
    }
    
    ///A structure that contains width and height values.
    struct CGSize
    {
        double width = 0;
        double height = 0;
        /// The size whose width and height are both zero.
        enum zero = CGSize(0, 0);
    }
    
    /**
    Returns a size with the specified dimension values.
    
    Params:
        width = A width value.
        height = A height value.
    Returns: Returns a CGSize structure with the specified width and height.
    */
    CGSize CGSizeMake(float width, float height);
}
