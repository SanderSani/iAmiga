//  Created by Emufreak on 31.1.2016
//
//  iUAE is free software: you may copy, redistribute
//  and/or modify it under the terms of the GNU General Public License as
//  published by the Free Software Foundation, either version 2 of the
//  License, or (at your option) any later version.
//
//  This file is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

#import <UIKit/UIKit.h>

@interface SettingsJoypadMainController : UITableViewController

@property (retain, nonatomic) IBOutlet UILabel *LabelDetection;
@property (retain, nonatomic) IBOutlet UISwitch *openServer;
@property (retain, nonatomic) IBOutlet UISwitch *sendToPort0;
@property (retain, nonatomic) IBOutlet UISwitch *sendToPort1;

@end
