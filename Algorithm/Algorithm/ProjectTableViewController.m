//
//  ProjectTableViewController.m
//  Algorithm
//
//  Created by LAL on 17/3/19.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "ProjectTableViewController.h"
#import "DescriptionViewController.h"
#import "PercolateImplementationViewController.h"
#import "CollinearImplementationViewController.h"
#import "PuzzleImplementationViewController.h"
#import "KdtreeImplementationViewController.h"
#import "EntryTableViewCell.h"
#import "HintViewController.h"

@interface ProjectTableViewController ()
@property (nonatomic, strong) NSArray *nameForIconImages;
@property (nonatomic, strong) NSArray *otherInfo;
@end

@implementation ProjectTableViewController

#pragma mark - Life Cycle

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.superview.mas_top).with.offset([self offsetHeightFromStatusBarAndNavigationBar]);
        make.bottom.equalTo(self.tableView.superview.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.tableView.superview.mas_centerX).with.multipliedBy(1.0);
        make.width.equalTo(self.tableView.superview.mas_width).with.multipliedBy(1.0);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.project.shortName;
    self.entries = [self createEntries];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.otherInfo = self.project.otherDetailInfo;
    self.nameForIconImages = @[@"descriptionIcon",@"hintIcon",@"implementationIcon",@"analysisIcon"];
    
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.entries.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntryCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.iconImageView.image = [UIImage imageNamed:self.nameForIconImages[indexPath.row]];
    cell.titleLabel.text = self.otherInfo[indexPath.row][0];
    cell.detailLabel.text = self.otherInfo[indexPath.row][1];
    cell.detailLabel.font = [UIFont fontWithName:@"HelveticaNeue-light" size:9];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
    cell.layer.borderColor = (__bridge CGColorRef _Nullable)[ColorStore basicThemeColor];
    cell.layer.borderWidth = 3;
    
    
    UIView *seperatorBottomView =[[UIView alloc] initWithFrame:CGRectMake(8, cell.frame.size.height, cell.frame.size.width-16, 0.5)];
    seperatorBottomView.backgroundColor = [ColorStore basicThemeColor];
    [cell addSubview:seperatorBottomView];
    
    UIView *backgroundSelectedView = [[UIView alloc] initWithFrame:cell.frame];
    backgroundSelectedView.backgroundColor = [[ColorStore basicThemeColor] colorWithAlphaComponent:0.25];
    cell.clipsToBounds = NO;
    [cell setSelectedBackgroundView:backgroundSelectedView];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *entry= self.entries[indexPath.row];
    if(entry == self.entries[0]){
        [self performSegueWithIdentifier:@"ToDescriptionViewController" sender:self];
    }else if(entry == self.entries[1]){
        [self performSegueWithIdentifier:@"ToHintViewController" sender:self];
    }
    else if(entry == self.entries[2]){
        if ([self.project.name isEqualToString:@"Project 1.1: Percolation"]){
            [self performSegueWithIdentifier:@"ToPercolateImplementationViewController" sender:self];
        }else if([self.project.name isEqualToString:@"Project 2.1: Collinear"]){
            [self performSegueWithIdentifier:@"ToCollinearImplementationViewController" sender:self];
        }else if([self.project.name isEqualToString:@"Project 3.1: 8 Puzzle"]){
            [self performSegueWithIdentifier:@"ToPuzzleImplementationViewController" sender:self];
        }else if([self.project.name isEqualToString:@"Project 3.2: Kd-Trees"]){
            [self performSegueWithIdentifier:@"ToKdtreeImplementationViewController" sender:self];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqual:@"ToDescriptionViewController"]){
        DescriptionViewController *dvc = [segue destinationViewController];
        dvc.project = self.project;
    }else if ([segue.identifier isEqualToString:@"ToHintViewController"]){
        HintViewController *hvc = [segue destinationViewController];
        hvc.project = self.project;
    }else{
        if([segue.identifier isEqual:@"ToPercolateImplementationViewController"]){
            PercolateImplementationViewController *pivc = [segue destinationViewController];
            pivc.project = self.project;
        }else if ([segue.identifier isEqual:@"ToCollinearImplementationViewController"]){
            CollinearImplementationViewController *civc = [segue destinationViewController];
            civc.project = self.project;
        }else if ([segue.identifier isEqual:@"ToPuzzleImplementationViewController"]){
            PuzzleImplementationViewController *pivc = [segue destinationViewController];
            pivc.project = self.project;
        } else if ([segue.identifier isEqual:@"ToKdtreeImplementationViewController"]){
            KdtreeImplementationViewController *kdtivc = [segue destinationViewController];
            kdtivc.project = self.project;
        }
        
    }

//    DLog(@"PTVC project name: %@",self.project.name);
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - Navigation

-(NSArray *)createEntries{
    NSArray *entries = @[@"Description",@"Hint",@"Implementation"];
    
    return entries;
}


@end
