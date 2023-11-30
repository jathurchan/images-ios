# Images App (iOS)

## Problem

Create an iOS app that enables users to search for images on Pixabay, select multiple images from the search results, scroll endlessly, and view the selected images in a slideshow.

## Proposed Solution

### Search & Select Multiple Images

Search for images using the Pixabay API, which gives you access to over 2 million images. Select as many images as you like from the search results.

![Search & select multiple images](/res/multiple/multiple_q_multiple_selected.png)


### Scroll Endlessly

Scroll endlessly without a hitch thanks to automatic content retrieval, asynchronous image loading and caching.

![Scroll endlessly](/res/multiple/multiple_q_loading.png)


### View Selected Images in a Slideshow

View selected images (at least 2) in a slideshow. The images change automatically every 3 seconds, or you can scroll them horizontally.

![View selected images in a slideshow](/res/multiple/q_japan_selected_images.png)


## Implementation Plan

- [x] Define the UI using Figma.
- [x] Implement the models `Hit` and `PixabayJSON`, make them decodable and write unit tests to test the decoding.
- [x] Create a `ImageGridViewController` class. Using a storyboard, Add a search bar, collection view and a toolbar to the root view controller. Add Auto Layout constraints using XCode. Connect the views to `ImageGridViewController`.
- [x] Create a Playground. Perform GET requests using Pixabay API, testing a variety of query parameters. Retrieve sample data for `q = ""` and `per_page = 20`.
- [x] Implement `ImageCache` to load images asychronously and cache them, using sample data URLs.
- [x] Implement collection view (cell registration and snapshot) to display images using `ImageCache` and sample data.
- [x] Implement `PixabayClient` to provide a method perform a specific query: `loadHits`
- [x] Implement `HitProvider` to replace sample data. The class provides the `hits` array to read and 2 methods to update the `hits` array: `loadFirstPageData` and `loadNextPageData`.
- [x] Enable search using the search bar
- [x] Enable infinite scrolling
- [x] Enable selecting and deselecting multiple images in the collection view
- [x] Add `cancel` and `done` buttons and `# image(s) selected` label to the toolbar. Make them update whenever images are selected/deselected and new search query is performed.
- [x] Implement the `ImagesViewController` to show the selected images in a slideshow (enable manual scrolling horizontally). Apply Auto Layout constraints programmatically (_used NSLayoutConstraint.activate([]) and VFL_) 
- [x] Test the application as a user, fix any bugs & monitor performance.
- [x] Add comments
- [x] Handle errors when loading `Hit` data from Pixabay
- [ ] Show errors using alert controllers
- [ ] Better handle caching images (limit memory usage)
- [ ] Make the app more accessible

## Appendix

### Fixed Problems

- Fixed CPU usage by not updating `hitsStore` data during cell registration.

### Problems To Fix

- **Fix Memory usage** (Caching without any limit): limit caching capacity using `totalCostLimit` and clear cache when performing a new query.

![Memory Usage](/res/memory_usage.png)

### Initial UI design using Figma

![GridViewController](/res/GridViewController.png)
![DetailViewController](/res/DetailViewController.png)
