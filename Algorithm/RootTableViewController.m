//
//  RootTableViewController.m
//  Algorithm
//
//  Created by LAL on 17/3/18.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "RootTableViewController.h"
#import "ProjectTableViewCell.h"
#import "ProjectTableViewController.h"
#import "PuzzleImplementationViewController.h"

@interface RootTableViewController ()

@property (nonatomic, strong) NSArray *projects;

@end

@implementation RootTableViewController

# pragma mark - Life Cycle

-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.superview.mas_top).with.offset([self offsetHeightFromStatusBarAndNavigationBar]);
        make.bottom.equalTo(self.tableView.superview.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.tableView.superview.mas_centerX).with.multipliedBy(1.0);
        make.width.equalTo(self.tableView.superview.mas_width).with.multipliedBy(1.0);
    }];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:[ColorStore basicThemeColor]];
    
    self.projects = [self createProjects];
    self.title = @"Algorithms";
    [self.tableView reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.projects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionProjects = self.projects[section];
    return sectionProjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectCell" forIndexPath:indexPath];
    
    Project *project = self.projects[indexPath.section][indexPath.row];
    cell.titleLabel.text = project.name;
    cell.detailLabel.text = project.shortDescription;
    cell.iconImageView.image = project.icon;
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
    cell.layer.borderColor = (__bridge CGColorRef _Nullable)[ColorStore basicThemeColor];
    cell.layer.borderWidth = 3;

    
    UIView *seperatorUpView =[[UIView alloc] initWithFrame:CGRectMake(8, 0.0, cell.frame.size.width-16, 0.5)];
    seperatorUpView.backgroundColor = [ColorStore basicThemeColor];
    [cell addSubview:seperatorUpView];
    
    UIView *seperatorBottomView =[[UIView alloc] initWithFrame:CGRectMake(8, cell.frame.size.height, cell.frame.size.width-16, 0.5)];
    seperatorBottomView.backgroundColor = [ColorStore basicThemeColor];
    [cell addSubview:seperatorBottomView];
    
    UIView *backgroundSelectedView = [[UIView alloc] initWithFrame:cell.frame];
    backgroundSelectedView.backgroundColor = [[ColorStore basicThemeColor] colorWithAlphaComponent:0.25];
    
    cell.clipsToBounds = NO;
    [cell setSelectedBackgroundView:backgroundSelectedView];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14]];
    
    label.textColor = [UIColor whiteColor];
    Project *project = self.projects[section][0];
   ;
    /* Section header is in 0th index... */
    label.text = project.chapterName;

    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.12f];
    view.layer.borderColor = (__bridge CGColorRef _Nullable)[ColorStore basicThemeColor];
    view.layer.borderWidth = 1;
    [view addSubview:label];
    
    UIView *seperatorView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 1.0)];
    seperatorView.backgroundColor = [ColorStore basicThemeColor];
    [view addSubview:seperatorView];
    
    return view;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 27;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self performSegueWithIdentifier:@"ToProjectTableViewController" sender:self];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ProjectTableViewController *ptvc = [segue destinationViewController];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    ptvc.project = self.projects[selectedIndexPath.section][selectedIndexPath.row];
}

#pragma mark - helper
-(NSArray *)createProjects{
    
    Project *unionFind = [[Project alloc] initWithIcon:[UIImage imageNamed:@"Project 1.1_Percolation"]
                                           chapterName:@"Chapter 1 Fundamentals"
                                                  name:@"Project 1.1: Percolation"
                                      shortDescription:@"Given a system of randomly distributed insulating and metallic materials: what fraction need to be metallic for the system to be an electrical conductor."
                                       fullDescription:@"Project 1.1_Percolation specification"
                                              fullHint:@"Project 1.1_Percolation_checklist"
                                       otherDetailInfo:@[@[@"Description",@"Given a system of randomly distributed insulating and metallic materials: what fraction need to be metallic for the system to be an electrical conductor."],
                                                         @[@"Hint",@"Data Strucure:  Array \nAlgorihms:  WeightedQuickUnionFind"],
                                                         @[@"Implementation",@"The implementation shows a visible change of n*n grids, After open a new grid, it is colored white; if it is also connected to the top, it is further colored as blue."],
                                                         @[@"Analysis",@"The time and space required for the algorithm and data structure"]]];
    
    Project *dequesAndQueues = [[Project alloc] initWithIcon:[UIImage imageNamed:@"Project 1.2_Deques & Random Queues.png"]
                                                 chapterName:@"Chapter 1 Fundamentals"
                                                        name:@"Project 1.2: Deques & Queues"
                                            shortDescription:@"Implement two general-purpose data structures using arrays, linked lists, generics, and iterators."
                                             fullDescription:@"Project 1.2_Deques & Randomized Queues_specification"
                                                    fullHint:@"Project 1.2_Deques & Randomized Queues_checklist"
                                             otherDetailInfo:nil];

    
    Project *collinear = [[Project alloc] initWithIcon:[UIImage imageNamed:@"Project 2.1_Collinear.png"]
                                              chapterName:@"Chapter 2 Sorting"
                                                     name:@"Project 2.1: Collinear"
                                         shortDescription:@"Efficiently find collinear points in 2D plane."
                                          fullDescription:@"Project 2.1_Collinear_specification"
                                                 fullHint:@"Project 2.1_Collinear_checklist"
                                       otherDetailInfo:@[@[@"Description",@"Efficiently find collinear points in 2D plane."],
                                                         @[@"Hint",@"Data Strucure:  Array\nAlgorihms:  Sorting"],
                                                         @[@"Implementation",@"The implementation shows a  basic image with all points that will be investigated. After collinear finding, lines are drawned with 4 collinear points."],
                                                         @[@"Analysis",@"The time and space required for the algorithm and data structure."]]];
    
    Project *autocomplete = [[Project alloc] initWithIcon:[UIImage imageNamed:@"Project 2.2_Autocomplete.png"]
                                              chapterName:@"Chapter 2 Sorting"
                                                     name:@"Project 2.2: Autocomplete"
                                         shortDescription:@"Implement text autocompletion by finding all terms beginning with a given prefix, sorted by associated weight."
                                          fullDescription:@"Project 2.2_Autocomplete_specification"
                                                 fullHint:@"Project 2.2_Autocomplete_checklist"
                                          otherDetailInfo:nil];
    
    Project *puzzle8  = [[Project alloc] initWithIcon:[UIImage imageNamed:@"Project 3.1_8-Puzzle.png"]
                                          chapterName:@"Chapter 3 Searching"
                                                 name:@"Project 3.1: 8 Puzzle"
                                     shortDescription:@"Write a program to solve the 8-puzzle problem (and its natural generalizations) using the A* search algorithm."
                                      fullDescription:@"Project 3.1_8-Puzzle_specification"
                                             fullHint:@"Project 3.1_8-Puzzle_checklist"
                                      otherDetailInfo:@[@[@"Description",@"Write a program to solve the 8-puzzle problem using the A* search algorithm."],
                                                        @[@"Hint",@"Data Strucure:  MinPQ\nAlgorihms:  A* search"],
                                                        @[@"Implementation",@"The implementation will generate a random 3*3 8-puzzle grids. After using A* search Algorithm, an animation will be available that leads to final answer step by step."],
                                                        @[@"Analysis",@"The time and space required for the algorithm and data structure"]]];
    
    Project *kdTrees = [[Project alloc] initWithIcon:[UIImage imageNamed:@"Project 3.2_Kd-Trees.png"]
                                         chapterName:@"Chapter 3 Searching"
                                                name:@"Project 3.2: Kd-Trees"
                                    shortDescription:@"Create a symbol table data type whose keys are two-dimensional points, supporting efficient range search and nearest neighbor search."
                                     fullDescription:@"Project 3.2_Kd-Trees_specification"
                                            fullHint:@"Project 3.2_Kd-Trees_checklist"
                                     otherDetailInfo:@[@[@"Description",@"Create a symbol table data type whose keys are two-dimensional points, supporting efficient range search and nearest neighbor search"],
                                                       @[@"Hint",@"Data Strucure:  KdTree\nAlgorihms:  KdTree Search"],
                                                       @[@"Implementation",@"The implementation will generate n random points (ranging from 10 to 100). The Kd-Tree will show a visible change for nearest point and points in a certain rectangle."],
                                                       @[@"Analysis",@"The time and space required for the algorithm and data structure"]]];
    Project *seamCarving = [[Project alloc] initWithIcon:[UIImage imageNamed:@"Project 4.2_SeamCarving"]
                                             chapterName:@"Chapter 4 Graphs"
                                                    name:@"Project 4.2: Seam Carving"
                                        shortDescription:@"Implement a content-aware image resizing algorithm where an image is reduced in size based on the pixels with the least \"energy\" content."
                                         fullDescription:@"Project 4.2_SeamCarving_specification"
                                                fullHint:@"Project 4.2_SeamCarving_checklist"
                                         otherDetailInfo:nil];
    
    NSArray *projects = @[@[unionFind],@[collinear],@[puzzle8,kdTrees]];
    
    return projects;
}

@end
