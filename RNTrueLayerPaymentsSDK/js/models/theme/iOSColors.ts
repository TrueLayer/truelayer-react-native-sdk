export type iOSColors = {
    backgroundColors?: BackgroundColor
    contentColors?: ContentColor
    accessoryColors?: AccessoryColor
  };

type BackgroundColor = {
  /// The primary color of the background of the views.
  backgroundPrimary?: string
  
  /// The secondary color of the background of the views.
  backgroundSecondary?: string
  
  /// The primary color of an action item such as a button (example: Continue).
  backgroundActionPrimary?: string

  /// The color of the background for the cells.
  backgroundCell?: string
}
  
type ContentColor = {
  /// The color of the primary content. That is any generic text around the `SDK`.
  contentPrimary?: string
  
  /// The color of secondary content. This is things like explanation text.
  contentSecondary?: string
  
  /// The system color for text on a dark background.
  contentPrimaryInverted?: string
  
  /// The color for text invoking an action. Like a link for instance.
  contentAction?: string
  
  /// The color of text displaying an error.
  contentError?: string
}
  
type AccessoryColor = {
  /// The color for thin borders or divider lines that allows some underlying content to be visible.
  separator?: string

  /// The color of the border of some content elements.
  ///
  /// This is mainly used inside the table view cells' images.
  uiElementBorder?: string
}