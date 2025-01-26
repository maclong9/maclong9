// See https://svelte.dev/docs/kit/types#app.d.ts
// for information about these interfaces
declare global {
	interface Post {
		title: string;
		slug: string;
		description: string;
		image: string;
		published: string;
		readTime: number;
		likes: number;
		category: string;
		tags: string[];
	}
	namespace App {}
}

export {};
