//
//  Shader.fsh
//  DrawImages
//
//  Created by Brett Graham on 12-07-05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
