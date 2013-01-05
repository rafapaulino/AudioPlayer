//
//  PrincipalViewController.h
//  AudioPlayer
//
//  Created by Rafael Brigagão Paulino on 19/09/12.
//  Copyright (c) 2012 rafapaulino.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PrincipalViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *tempoAtual;
@property (nonatomic, weak) IBOutlet UILabel *tempoTotal;
@property (nonatomic, weak) IBOutlet UISlider *sliderTempo;
@property (nonatomic, weak) IBOutlet UISlider *sliderVolume;
@property (nonatomic, weak) IBOutlet UITableView *tabela;

//botoes
-(IBAction)playClicado:(id)sender;
-(IBAction)stopClicado:(id)sender;
-(IBAction)avancarClicado:(id)sender;
-(IBAction)voltarClicado:(id)sender;
-(IBAction)pauseClicado:(id)sender;
//sliders
-(IBAction)sliderTempoMudouValor:(id)sender;
-(IBAction)sliderVolumeMudouValor:(id)sender;
-(IBAction)alteracaoTempoTerminou:(id)sender;

@end
