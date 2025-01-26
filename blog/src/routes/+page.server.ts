import { error } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async () => {
	try {
		// const posts = await Promise.all(
		// 	Object.entries(import.meta.glob<{ metadata: Post }>('/src/posts/*.md')).map(
		// 		async ([path, resolver]) => {
		// 			const post = await resolver();
		// 			if (!post || !post.metadata) {
		// 				throw new Error(`Invalid post data for ${path}`);
		// 			}

		// 			const slug = path.split('/').pop()?.replace('.md', '');
		// 			if (!slug) {
		// 				throw new Error(`Could not generate slug for ${path}`);
		// 			}

		// 			return {
		// 				...post.metadata
		// 			} as Post;
		// 		}
		// 	)
		// );

		// const sortedPosts = posts.sort(
		// 	(a, b) => new Date(b.date).getTime() - new Date(a.date).getTime()
		// );

		return { posts: [] };
	} catch (err) {
		throw error(500, {
			message: `Could not load posts - ${err instanceof Error ? err.message : 'Unknown error'}`
		});
	}
};
