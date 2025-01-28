import { error } from '@sveltejs/kit';
import type { PageLoad } from './$types';

// Define interfaces for better type safety
interface PostMetadata {
	title: string;
	description: string;
	category: string;
	image: string;
	published: string;
	likes: number;
	readTime: number;
}

interface PostModule {
	metadata: PostMetadata;
	default: { length: number };
}

// Import all markdown files from posts directory
const posts = Object.entries(import.meta.glob<PostModule>('/src/posts/**/*.md', { eager: true }));

export const load: PageLoad = async () => {
	try {
		// Process and sort posts
		const processedPosts = posts
			.map((entry) => {
				const [path, post] = entry;
				const pathParts = path.split('/');
				const filename = pathParts[pathParts.length - 1]?.replace('.md', '');

				return {
					path: `/posts/${filename}`,
					title: post.metadata?.title ?? 'Untitled Post',
					description: post.metadata?.description ?? 'No description available',
					category: post.metadata?.category ?? 'Uncategorized',
					image: post.metadata?.image ?? '/placeholder.svg',
					published: post.metadata?.published ?? new Date().toISOString(),
					likes: post.metadata?.likes ?? 0,
					readTime: post.metadata?.readTime ?? Math.ceil((post.default?.length ?? 0) / 1500)
				};
			})
			.sort((a, b) => new Date(b.published).getTime() - new Date(a.published).getTime());

		return {
			posts: processedPosts
		};
	} catch (err) {
		console.error('Error loading posts:', err);
		throw error(500, 'Error loading posts');
	}
};
