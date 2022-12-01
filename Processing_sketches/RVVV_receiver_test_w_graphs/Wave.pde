class Wave{
  int offT = 100;
	int w = width - offT;
	int h = width - offT;
	int n_els = 40;
	float spX = w / n_els;
	float wPosX;
	float wPosY;
	float wPosZ;
	float rotInd = 0;
	float sinInd = 0;
  float sinIndX = 1;
  float sinIndY = 0;
  float sinIndZ = 0;
  char currentRot = 'z';
  char prevRot = 'z';
	float amp = 0;
	ArrayList<Sound> sounds;
  int prevNumSound = 0;
  color fillColor;
  float generalAmplitude = 0;
	Wave(float x, float y, float z){
		wPosX = x;
		wPosY = y;
		wPosZ = z;
		sounds = new ArrayList<Sound>();
    fillColor = color(150, 150, 150);
	}
  void manageRotationIndex() {
    switch(currentRot) {
      case 'x':
        if(currentRot != prevRot) {
          rotInd = sinIndX;      
        }
        sinIndX = rotInd;
        break;
      case 'y':
        if(currentRot != prevRot) {
          rotInd = sinIndY;      
        }
        sinIndY = rotInd;
        break;
      case 'z':
        if(currentRot != prevRot) {
          rotInd = sinIndZ;      
        }
        sinIndZ = rotInd;
        break;
    }
    prevRot = currentRot;
    rotateX(sinIndX);
    rotateY(sinIndY);
    rotateZ(sinIndZ);
  }
	void draw(){
		push();
		rotInd = rotInd > 2*PI ? rotInd%(2*PI) : rotInd + 0.005;
		sinInd = sinInd > 2*PI ? sinInd%(2*PI) : sinInd + 1000;
		translate((width/2), (height/2));
		manageRotationIndex();
		translate((-width/2), (-height/2));
		noFill();
		strokeWeight(2);
		stroke(fillColor);
		// amp = amp != 0 ? (amp < 0 ? 0 : amp - (amp / (200 / 50))) : 0;
		for(int s = 0; s < sounds.size(); s++){
			Sound snd = sounds.get(s);
			if(snd.currAmp <= 0){
				sounds.remove(s);
			}else{
				snd.currAmp -= snd.amp / (snd.dur/(1000 / 50));
			}
		}
		for(int x = 0; x < n_els; x++){
			beginShape(POINTS);
			for(int y = 0; y < n_els; y++){
				float offz = 0;
				for(int s = 0; s < sounds.size(); s++){
          			Sound snd = sounds.get(s);
					offz += snd.currAmp*sin(sinInd + map(y, 0, n_els, 0, (PI))) + 
					snd.currAmp*sin(sinInd + map(x, 0, n_els, 0, (2*PI)*snd.freq) + map(y, 0, n_els, 0, (2*PI)*snd.freq));
				}

        if(generalAmplitude > 0){
                    offz += generalAmplitude*sin(sinInd + map(y, 0, n_els, 0, (PI))) + 
          generalAmplitude*sin(sinInd + map(x, 0, n_els, 0, (2*PI)*3) + map(y, 0, n_els, 0, (2*PI)*3));
        }
				// float localSin1 = amp*sin(sinInd + map(y, 0, n_els, 0, (2*PI)*30));
				// float localSin2 = amp*sin(sinInd + map(y, 0, n_els, 0, (2*PI)*2));
				// float localSin3 = amp*sin(sinInd + map(x, 0, n_els, 0, (2*PI)*30));
				// float localSin4 = amp*sin(sinInd + map(x, 0, n_els, 0, (2*PI)*2));
				vertex(x*spX + wPosX + (offT/2), y*spX + wPosY + (offT/2), offz + wPosZ);
				// vertex(x*spX + wPosX, y*spX + wPosY, localSin1 + localSin2 + localSin3 + localSin4 + wPosZ);
			}
			endShape();
		}
		//rotateZ(0);
		//rotateX(-1);
		pop();
	}
}
