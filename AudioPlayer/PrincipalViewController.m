//
//  PrincipalViewController.m
//  AudioPlayer
//
//  Created by Rafael Brigagão Paulino on 19/09/12.
//  Copyright (c) 2012 rafapaulino.com. All rights reserved.
//

#import "PrincipalViewController.h"

@interface PrincipalViewController ()
{
    NSArray *listaMusicas;
    AVAudioPlayer *player;
    NSTimer *temporizador;
    BOOL mudandoTempo;
}

@end

@implementation PrincipalViewController


-(void)prepararFaixa:(NSIndexPath*)indiceFaixa
{
    NSString *caminhoArquivoAudio = [[NSBundle mainBundle] pathForResource:[listaMusicas objectAtIndex:indiceFaixa.row] ofType:@"m4a"];
    
    //criando uma url para localizar o arquivo de audio
    NSURL *urlFaixa = [NSURL fileURLWithPath:caminhoArquivoAudio];
    
    //inicializar o player
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:urlFaixa error:nil];
    
    //ajustar o slider tempo
    _sliderTempo.maximumValue = player.duration;
    _sliderTempo.value = 0;
    
    //ajustar o tempo total na label
    NSString *tempoTotalFaixa = [NSString stringWithFormat:@"%02d:%02d", (int)player.duration/60,(int)player.duration%60];
    _tempoTotal.text = tempoTotalFaixa;
    
    //pedimos para o player carregar a faixa deixando tudo pronto para a execucao
    [player prepareToPlay];
}

//metodos da tabela
//numeros de linhas natabela
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listaMusicas.count;
}
//cria as celulas
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idCelula = @"minhaCelula";
    UITableViewCell *celula = [tableView dequeueReusableCellWithIdentifier:idCelula];
    
    if (celula == nil) {
        celula = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idCelula];
    }
    
    celula.textLabel.text = [listaMusicas objectAtIndex:indexPath.row];
    
    return celula;
}
//clica na tabela
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self prepararFaixa:indexPath];
    [self playClicado:nil];
}


//botoes
-(IBAction)playClicado:(id)sender
{
    //se o player estiver tocando ele volta para o comeco 
    if (player.playing)
    {
        player.currentTime = 0;
    }
    //caso contrario ele toca
    else
    {
        [player play];
    }
}

-(IBAction)stopClicado:(id)sender
{
    [player stop];
    player.currentTime = 0;
}

-(IBAction)avancarClicado:(id)sender
{
    //descobrir qul indexpth da faixa
    NSIndexPath *celulaSelecionada = [_tabela indexPathForSelectedRow];
    
    //VERIFICACAO SE ESTA JA NAO e a ultima celula
    if (celulaSelecionada.row < listaMusicas.count -1)
    {
        //preparar a pro faixa
        NSIndexPath *proximaFaixa = [NSIndexPath indexPathForRow:celulaSelecionada.row+1 inSection:0];
        
        //atualizar aminha tabela visualmente
        [_tabela selectRowAtIndexPath:proximaFaixa animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        //pedindo para o player preparar a faixa
        //[self prepararFaixa:proximaFaixa];
        [self tableView:_tabela didSelectRowAtIndexPath:proximaFaixa];
    }
}

-(IBAction)voltarClicado:(id)sender
{
    //descobrir qul indexpth da faixa
    NSIndexPath *celulaSelecionada = [_tabela indexPathForSelectedRow];
    
    //VERIFICACAO SE ESTA JA NAO e a ultima celula
    if (celulaSelecionada.row > 0)
    {
        //preparar a pro faixa
        NSIndexPath *faixaAnterior = [NSIndexPath indexPathForRow:celulaSelecionada.row-1 inSection:0];
        
        //atualizar aminha tabela visualmente
        [_tabela selectRowAtIndexPath:faixaAnterior animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        //pedindo para o player preparar a faixa
        [self tableView:_tabela didSelectRowAtIndexPath:faixaAnterior];
    }
}

-(IBAction)pauseClicado:(id)sender
{
    [player pause];
}

//sliders
//valuechange
-(IBAction)sliderTempoMudouValor:(id)sender
{
    mudandoTempo = YES;
    _tempoAtual.text = [NSString stringWithFormat:@"%02d:%02d", (int)_sliderTempo.value/60, (int)_sliderTempo.value%60];
}

-(IBAction)sliderVolumeMudouValor:(id)sender
{
    player.volume = _sliderVolume.value;
    
}
//touchup inside 
-(IBAction)alteracaoTempoTerminou:(id)sender
{
    mudandoTempo = NO;
    
    //slatando a faixa para o momento escolhido pelo usuario atraves do slider
    player.currentTime = _sliderTempo.value;
}

//muda o tempo caso a pessoa nao mexa no slider
-(void)atualizarInterface
{
    _tempoAtual.text = [NSString stringWithFormat:@"%02d:%02d", (int)player.currentTime/60, (int)player.currentTime%60];
    
    //atualizar o slider de tempo da faixa caso o usuario nao esteja tocando o mesmo (slider)
    if (mudandoTempo == NO)
    {
        _sliderTempo.value = player.currentTime;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //inicializar o array que ira armazenas a lista de musicas
    listaMusicas = [[NSArray alloc] initWithObjects:@"Do You",@"Dog Days",@"Paradise", nil];
    
    //selecionar visualmente na tabela (simulando um toque na celula)
    [_tabela selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    //pedindo para o player preparar a primeira faixa
    [self prepararFaixa:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    //associar o volume do aparelho ao volume do app
    _sliderVolume.value = [[MPMusicPlayerController iPodMusicPlayer] volume];
    
    mudandoTempo = NO;
    
    //preparar o timer que ira atualizar a interface 1 vez por segundo
    temporizador = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(atualizarInterface) userInfo:nil repeats:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
